import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _searchController = TextEditingController();
  LatLng _center = LatLng(40.7128, -74.0060); // Default: New York City
  List<Marker> _markers = []; // List of markers for the map

  // Geocoding simulation: Add your cities here
  void _onSearch(String query) {
    final mockGeocode = {
      "athens": LatLng(37.9838, 23.7275), // Athens, Greece
      "paris": LatLng(48.8566, 2.3522), // Paris, France
      "new york": LatLng(40.7128, -74.0060), // New York City
    };

    LatLng? newCenter = mockGeocode[query.toLowerCase()];
    if (newCenter != null) {
      setState(() {
        _center = newCenter; // Update map center
        _markers = [
          Marker(
            point: newCenter,
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
    } else {
      // If city not found, clear markers
      setState(() {
        _markers = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('City "$query" not found!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fullscreen map
          FlutterMap(
            options: MapOptions(
              center: _center,
              zoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(markers: _markers),
            ],
          ),
          // Search bar positioned at the top
          Positioned(
            top: MediaQuery.of(context).padding.top + 10, // Below status bar
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
                    onPressed: () => _onSearch(_searchController.text),
                  ),
                ),
                onSubmitted: _onSearch,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Map screen index
        onTap: (index) {
          // Handle navigation if needed
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Challenges',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
