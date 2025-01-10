import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async'; // For StreamSubscription
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore integration

class MapScreen extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  LatLng _center = LatLng(0, 0); // Default map center
  List<Marker> _markers = []; // List to store search markers
  Marker? _liveLocationMarker; // Marker for live location
  StreamSubscription<Position>? _positionStream; // For live location updates

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _startLiveLocation();
  }

  @override
  void dispose() {
    _stopLiveLocation(); // Stop the location stream
    _searchController.dispose(); // Dispose search controller
    super.dispose();
  }

  // Check and request location permissions
  Future<void> _checkPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are denied.')),
        );
        return;
      }
    }
  }

  // Start live location tracking
  void _startLiveLocation() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 5, // Update every 5 meters
      ),
    ).listen((Position position) {
      LatLng newLocation = LatLng(position.latitude, position.longitude);
      setState(() {
        _liveLocationMarker = Marker(
          point: newLocation,
          width: 80.0,
          height: 80.0,
          builder: (ctx) => Icon(
            Icons.my_location,
            color: Colors.blue,
            size: 40.0,
          ),
        );
      });
      _mapController.move(newLocation, 15.0); // Center map on new location
    });
  }

  // Stop live location tracking
  void _stopLiveLocation() {
    _positionStream?.cancel();
  }

  // Parse location from Firestore (GeoPoint or string)
  LatLng parseLocation(dynamic location) {
    if (location is GeoPoint) {
      return LatLng(location.latitude, location.longitude);
    } else if (location is String) {
      final parts = location.split(',');
      final latitude = double.parse(parts[0].trim());
      final longitude = double.parse(parts[1].trim());
      return LatLng(latitude, longitude);
    }
    throw Exception("Invalid location format");
  }

  // Search for a city in Firestore
  void _onSearch(String query) async {
    try {
      if (query.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a city name to search.')),
        );
        return;
      }

      query = query.toLowerCase(); // Convert query to lowercase for matching

      // Fetch cities from Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('cities')
          .get(); // Adjust 'cities' to match your Firestore collection name

      // Filter cities by name
      final matchingCities = snapshot.docs.where((doc) {
        final cityName = (doc.data()['CityName'] as String).toLowerCase();
        return cityName.contains(query);
      }).toList();

      if (matchingCities.isNotEmpty) {
        final data = matchingCities.first.data();
        final location = data['Location']; // Firestore field for location
        final LatLng cityLocation = parseLocation(location);

        setState(() {
          _center = cityLocation;
          _markers = [
            Marker(
              point: cityLocation,
              width: 80.0,
              height: 80.0,
              builder: (ctx) => Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 40.0,
              ),
            ),
          ];
        });
        _mapController.move(cityLocation, 13.0); // Move map to city
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('City "$query" not found!')),
        );
      }
    } catch (e) {
      print("Error during search: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _center,
              zoom: 5.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  ..._markers, // Add search markers
                  if (_liveLocationMarker != null) _liveLocationMarker!,
                ],
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 15.0,
            right: 15.0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
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
                    icon: Icon(Icons.search),
                    onPressed: () => _onSearch(_searchController.text.trim()),
                  ),
                ),
                onSubmitted: (value) => _onSearch(value.trim()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
