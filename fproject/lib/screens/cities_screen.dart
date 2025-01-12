import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CitiesScreen extends StatefulWidget {
  const CitiesScreen({Key? key}) : super(key: key);

  @override
  State<CitiesScreen> createState() => _CitiesScreenState();
}

class _CitiesScreenState extends State<CitiesScreen> {
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

      if (visitedCityNames.isEmpty) {
        setState(() {
          visitedCities = []; // No cities visited
        });
        return;
      }

      final cities = await Future.wait(visitedCityNames.map((cityName) async {
        final cityDoc = await FirebaseFirestore.instance.collection('cities').doc(cityName).get();
        if (cityDoc.exists) {
          return {
            'name': cityName,
            'image': (cityDoc.data()?['CityImages'] ?? [])[0], // First image from CityImages
            'description': cityDoc.data()?['CityDescription'] ?? "No description available."
          };
        } else {
          return {'name': cityName, 'image': null, 'description': "No description available."};
        }
      }));

      setState(() {
        visitedCities = cities;
      });
    } catch (e) {
      print('Error fetching visited cities: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Cities',
          style: TextStyle(color: Colors.black),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.black,
            height: 3.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: visitedCities.isEmpty
          ? const Center(child: Text("No visited cities yet."))
          : ListView.builder(
              padding: const EdgeInsets.all(20.0),
              itemCount: visitedCities.length,
              itemBuilder: (context, index) {
                final city = visitedCities[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade800,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: city['image'] != null
                              ? NetworkImage(city['image'])
                              : null,
                          backgroundColor: Colors.white,
                          child: city['image'] == null
                              ? Text(
                                  city['name'][0].toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.grey, fontWeight: FontWeight.bold),
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                city['name'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                city['description'],
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}