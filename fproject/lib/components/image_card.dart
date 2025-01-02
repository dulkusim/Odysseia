import 'package:flutter/material.dart';
import 'package:fproject/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CityCard extends StatelessWidget {
  final String cityName;

  const CityCard({required this.cityName, Key? key}) : super(key: key);

  Future<String?> fetchCityImage(String cityName) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('cities').doc(cityName.toLowerCase()).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null && data['CityImages'] != null && data['CityImages'].isNotEmpty) {
          return data['CityImages'][0]; // Fetch the first image URL
        }
      }
      return null; // Return null if no image found
    } catch (e) {
      print('Error fetching image for $cityName: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to City Page Info screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CityPageInfo(cityName: cityName),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0), // Adds spacing to the right
        child: Column(
          children: [
            FutureBuilder<String?>(
              future: fetchCityImage(cityName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: 117,
                    height: 80,
                    color: Colors.grey.shade300,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError || snapshot.data == null) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      width: 117,
                      height: 80,
                      color: Colors.grey.shade300,
                      child: Icon(Icons.image, size: 40, color: Colors.grey),
                    ),
                  );
                } else {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      snapshot.data!,
                      width: 139,
                      height: 95,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade300,
                          width: 139,
                          height: 90,
                          child: Icon(Icons.error, color: Colors.red),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 8),
            Text(
              cityName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
