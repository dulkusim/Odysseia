import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'section_header.dart';

class CitiesSection extends StatefulWidget {
  final VoidCallback onShowAllPressed;

  const CitiesSection({Key? key, required this.onShowAllPressed}) : super(key: key);

  @override
  State<CitiesSection> createState() => _CitiesSectionState();
}

class _CitiesSectionState extends State<CitiesSection> {
  List<Map<String, dynamic>> visitedCities = [];

  @override
  void initState() {
    super.initState();
    fetchVisitedCities();
  }

  Future<void> fetchVisitedCities() async {
  try {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = FirebaseFirestore.instance.collection('Users').doc(userId);

    final userSnapshot = await userDoc.get();
    final visitedCityNames = List<String>.from(userSnapshot.data()?['visitedcities'] ?? []);

    // If the list is empty, set an empty visitedCities list and return early
    if (visitedCityNames.isEmpty) {
      setState(() {
        visitedCities = [];
      });
      return;
    }

    // Fetch city details for each visited city
    final cities = await Future.wait(visitedCityNames.map((cityName) async {
      try {
        final cityDoc = await FirebaseFirestore.instance.collection('cities').doc(cityName.toLowerCase()).get();

        // Handle cases where the city document might not exist
        if (!cityDoc.exists) {
          return {
            'name': cityName,
            'image': null, // Default to no image
          };
        }

        return {
          'name': cityName,
          'image': (cityDoc.data()?['CityImages'] ?? [])[0], // Get the first image or default to null
        };
      } catch (e) {
        print("Error fetching city document for $cityName: $e");
        return {
          'name': cityName,
          'image': null, // Default to no image
        };
      }
    }));

    setState(() {
      visitedCities = cities;
    });
  } catch (e) {
    print("Error fetching visited cities: $e");
    setState(() {
      visitedCities = []; // Default to empty list in case of error
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: "Cities", onShowAllPressed: widget.onShowAllPressed),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            if (index < visitedCities.length) {
              final city = visitedCities[index];
              return CircleAvatar(
                radius: 30,
                backgroundImage: city['image'] != null
                    ? NetworkImage(city['image'])
                    : null,
                backgroundColor: Colors.grey[300],
                child: city['image'] == null
                    ? Text(
                        city['name'][0], // Fallback to first letter
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    : null,
              );
            } else {
              return CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.location_city, color: Colors.grey),
              );
            }
          }),
        ),
      ],
    );
  }
}
