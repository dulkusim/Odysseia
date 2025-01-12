// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async'; // For subscription
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Simple data class for a challenge.
class MapChallenge {
  final String id;
  final String name;
  final String category;
  final String? imageUrl;
  final LatLng location;

  MapChallenge({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    this.imageUrl,
  });
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  // Location & map
  final MapController _mapController = MapController();
  Position? _lastKnownPosition;
  bool _hasCenteredOnUser = false;
  StreamSubscription<Position>? _positionSub;

  // Searching
  final TextEditingController _searchController = TextEditingController();

  // Current city challenges & subscriptions
  List<MapChallenge> _gpsChallenges = [];
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _userDocSub;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _cityChallengesSub;
  String _currentCity = '';

  // Carousel
  final PageController _pageController = PageController(viewportFraction: 0.7);
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _startLiveLocation();
    _listenToUserDoc(); // watch user doc for current_city changes

    // Listen to PageView scroll => update selectedIndex => optionally center map
    _pageController.addListener(() {
      final pageValue = _pageController.page;
      if (pageValue != null) {
        final newIndex = pageValue.round();
        if (newIndex != _selectedIndex && newIndex < _gpsChallenges.length) {
          setState(() => _selectedIndex = newIndex);
          final loc = _gpsChallenges[newIndex].location;
          _mapController.move(loc, 15.0);
        }
      }
    });
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _userDocSub?.cancel();
    _cityChallengesSub?.cancel();
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // 1) PERMISSIONS
  // ---------------------------------------------------------------------------
  Future<void> _checkPermissions() async {
    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
      perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
      }
    }
  }

  // ---------------------------------------------------------------------------
  // 2) LIVE LOCATION
  // ---------------------------------------------------------------------------
  void _startLiveLocation() {
    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 5,
      ),
    ).listen((pos) {
      _lastKnownPosition = pos;

      // Only center once
      if (!_hasCenteredOnUser) {
        _hasCenteredOnUser = true;
        _mapController.move(LatLng(pos.latitude, pos.longitude), 15.0);
      }
      setState(() {}); // rebuild to show the blue location dot
    });
  }

  // ---------------------------------------------------------------------------
  // 3) LISTEN to user doc => find current_city => then watch city challenges
  // ---------------------------------------------------------------------------
  void _listenToUserDoc() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _userDocSub = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .snapshots()
        .listen((userSnap) {
      if (!userSnap.exists) {
        _clearChallenges();
        return;
      }
      final data = userSnap.data() ?? {};
      final newCity = data['current_city'] ?? '';
      if (newCity != _currentCity) {
        // current city changed => re-subscribe
        _currentCity = newCity;
        _subscribeToCityChallenges(newCity);
      }
    });
  }

  // Clear local challenges
  void _clearChallenges() {
    setState(() {
      _gpsChallenges = [];
      _selectedIndex = 0;
      _currentCity = '';
    });
  }

  // ---------------------------------------------------------------------------
  // 4) SUBSCRIBE to city’s challenges => store them in _gpsChallenges
  // ---------------------------------------------------------------------------
  void _subscribeToCityChallenges(String cityName) {
    // Cancel old sub first
    _cityChallengesSub?.cancel();
    _cityChallengesSub = null;
    _clearChallenges(); // reset local challenges

    if (cityName.isEmpty) {
      return; // means user ended trip => no challenges
    }

    final cityDocRef = FirebaseFirestore.instance
        .collection('cities')
        .doc(cityName.toLowerCase());

    _cityChallengesSub = cityDocRef
        .collection('challenges')
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> snap) {
      final newList = <MapChallenge>[];
      for (var doc in snap.docs) {
        final data = doc.data();
        final bool gpsOk = data['gps_verifiable'] == true;
        final bool hasLoc = data['location'] != null;
        if (!gpsOk || !hasLoc) continue;

        final loc = _parseLocation(data['location']);
        newList.add(
          MapChallenge(
            id: doc.id,
            name: data['name'] ?? 'Unnamed',
            category: data['category'] ?? 'Unknown',
            imageUrl: data['image'],
            location: loc,
          ),
        );
      }
      setState(() {
        _gpsChallenges = newList;
        // Make sure index is in range
        if (_selectedIndex >= _gpsChallenges.length && _gpsChallenges.isNotEmpty) {
          _selectedIndex = 0;
        }
      });
    });
  }

  // ---------------------------------------------------------------------------
  // 5) SEARCH (no extra pin)
  // ---------------------------------------------------------------------------
  Future<void> _onSearch(String query) async {
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a city name.')),
      );
      return;
    }
    try {
      query = query.toLowerCase();
      final snap = await FirebaseFirestore.instance.collection('cities').get();
      final matching = snap.docs.where((doc) {
        final cityName = (doc.data()['CityName'] ?? '').toString().toLowerCase();
        return cityName.contains(query);
      }).toList();

      if (matching.isNotEmpty) {
        final loc = matching.first.data()['Location'];
        final latLng = _parseLocation(loc);
        _mapController.move(latLng, 13.0);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('City "$query" not found!')),
        );
      }
    } catch (e) {
      print("Error on search: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  LatLng _parseLocation(dynamic location) {
    if (location is GeoPoint) {
      return LatLng(location.latitude, location.longitude);
    } else if (location is String) {
      final parts = location.split(',');
      final lat = double.parse(parts[0].trim());
      final lng = double.parse(parts[1].trim());
      return LatLng(lat, lng);
    }
    throw Exception("Invalid location format");
  }

  // ---------------------------------------------------------------------------
  // 6) BUILD
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // a) The Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: LatLng(0, 0), // We'll re-center once on user
              zoom: 3.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a','b','c'],
              ),
              MarkerLayer(markers: _buildMarkers()),
            ],
          ),

          // b) Search bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 15.0,
            right: 15.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search for a city",
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => _onSearch(_searchController.text.trim()),
                  ),
                ),
                onSubmitted: (val) => _onSearch(val.trim()),
              ),
            ),
          ),

          // c) The Carousel
          if (_gpsChallenges.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 180,
                color: Colors.white,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _gpsChallenges.length,
                  onPageChanged: (idx) {
                    setState(() => _selectedIndex = idx);
                    final loc = _gpsChallenges[idx].location;
                    _mapController.move(loc, 15.0);
                  },
                  itemBuilder: (ctx, idx) {
                    final c = _gpsChallenges[idx];
                    final isSelected = (idx == _selectedIndex);
                    return _MapChallengeCard(challenge: c, isSelected: isSelected);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 7) BUILD MARKERS => live location + challenge pins
  // ---------------------------------------------------------------------------
  List<Marker> _buildMarkers() {
    final markers = <Marker>[];

    // Live location
    if (_lastKnownPosition != null) {
      markers.add(
        Marker(
          point: LatLng(_lastKnownPosition!.latitude, _lastKnownPosition!.longitude),
          width: 80,
          height: 80,
          builder: (_) => const Icon(
            Icons.my_location,
            color: Colors.blue,
            size: 40,
          ),
        ),
      );
    }

    // Challenge pins
    for (int i = 0; i < _gpsChallenges.length; i++) {
      final challenge = _gpsChallenges[i];
      final isSelected = (i == _selectedIndex);
      final pinSize = isSelected ? 46.0 : 32.0;
      final pinColor = isSelected ? Colors.red : Colors.deepOrange;

      markers.add(
        Marker(
          point: challenge.location,
          width: pinSize,
          height: pinSize,
          builder: (_) => GestureDetector(
            onTap: () {
              // Tapping => scroll carousel
              _pageController.animateToPage(
                i,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Icon(Icons.location_on, color: pinColor, size: pinSize),
          ),
        ),
      );
    }
    return markers;
  }
}

// A single card in the carousel
class _MapChallengeCard extends StatelessWidget {
  final MapChallenge challenge;
  final bool isSelected;

  const _MapChallengeCard({
    Key? key,
    required this.challenge,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scale = isSelected ? 1.0 : 0.95;

    return Center(
      child: Transform.scale(
        scale: scale,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          width: 220,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
            image: challenge.imageUrl != null
                ? DecorationImage(
                    image: NetworkImage(challenge.imageUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  challenge.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  challenge.category,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
