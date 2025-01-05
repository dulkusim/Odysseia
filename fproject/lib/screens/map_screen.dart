import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapScreen extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  LatLng _center = LatLng(0, 0); // Default center (whole world)
  List<Marker> _markers = []; // Start with no markers

  @override
  void dispose() {
    _searchController.dispose(); // Dispose the controller to avoid memory leaks
    super.dispose();
  }

  LatLng parseLocation(dynamic location) {
    try {
      if (location is GeoPoint) {
        // If location is a GeoPoint, directly use its latitude and longitude
        return LatLng(location.latitude, location.longitude);
      } else if (location is String) {
        // If location is a String, parse it
        final cleanString = location.replaceAll(RegExp(r'[^\d.,-]'), '');
        final parts = cleanString.split(',');

        final latitude = double.parse(parts[0].trim());
        final longitude = double.parse(parts[1].trim());

        return LatLng(latitude, longitude);
      } else {
        throw Exception("Invalid location type");
      }
    } catch (e) {
      print("Error parsing location: $location, Error: $e");
      throw Exception("Invalid location format");
    }
  }

  void _onSearch(String query) async {
    try {
      print("Searching for city: $query");

      // Convert query to lowercase to match the lowercase database fields
      query = query.toLowerCase();

      // Fetch all cities and filter by lowercase match
      final snapshot = await FirebaseFirestore.instance.collection('cities').get();

      // Filter cities manually
      final matchingCities = snapshot.docs.where((doc) {
        final cityName = (doc.data()['CityName'] as String).toLowerCase();
        return cityName == query;
      }).toList();

      print("Number of matching cities: ${matchingCities.length}");

      if (matchingCities.isNotEmpty) {
        final data = matchingCities.first.data();
        print("City data: $data");

        final location = data['Location'];

        // Parse the location into LatLng
        final LatLng cityLocation = parseLocation(location);

        if (mounted) {
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

          _mapController.move(cityLocation, 13.0);
        }
      } else {
        print("No matching city found.");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('City "$query" not found!')),
          );
        }
      }
    } catch (e) {
      print("Error occurred during search: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
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
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(markers: _markers),
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
