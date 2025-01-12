import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class ChallengeCardReal extends StatelessWidget {
  final String title; // Challenge name
  final String category; // Challenge category
  final String? imageUrl; // Image for the challenge
  final Map<String, dynamic>? location; // Challenge location (latitude, longitude)
  final VoidCallback onRefresh; // Callback for refresh button
  final VoidCallback onDelete; // Callback for delete button

  const ChallengeCardReal({
    Key? key,
    required this.title,
    required this.category,
    this.imageUrl,
    this.location,
    required this.onRefresh,
    required this.onDelete,
  }) : super(key: key);

  Future<void> _checkLocation(BuildContext context) async {
    // Ensure location is present and properly formatted
    if (location == null || location!['latitude'] == null || location!['longitude'] == null) {
      _showDialog(
        context,
        title: "No Location",
        content: "This challenge doesn't have a valid location to verify.",
      );
      return;
    }

    try {
      // Get the user's current location
      Position userPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      // Calculate distance between user and challenge location
      double distance = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        location!['latitude'],
        location!['longitude'],
      );

      if (distance <= 5000) {
        // User is within 5000 meters
        _showDialog(
          context,
          title: "Challenge Completed!",
          content: "You are within 5000 meters of the challenge location.",
        );
      } else {
        // User is not within 500 meters
        _showDialog(
          context,
          title: "Not the Right Location",
          content: "You are not within 5000 meters of the challenge location.",
        );
      }
    } catch (e) {
      // Handle location fetching errors
      print("Error fetching location: $e");
      _showDialog(
        context,
        title: "Error",
        content: "Unable to fetch your location. Please enable GPS and try again.",
      );
    }
  }

  void _showDialog(BuildContext context, {required String title, required String content}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 2, 6, 109),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                      child: imageUrl != null
                          ? Image.network(
                              imageUrl!,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.error, color: Colors.red, size: 50),
                              ),
                            )
                          : Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.image, size: 50.0, color: Colors.grey),
                              ),
                            ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                CupertinoIcons.camera,
                                color: Colors.white,
                                size: 25,
                              ),
                              onPressed: () {
                                print("Camera button pressed");
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                CupertinoIcons.map,
                                color: Colors.white,
                                size: 25,
                              ),
                              onPressed: () => _checkLocation(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 5.0, bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                CupertinoIcons.arrow_2_circlepath,
                                color: Colors.white,
                                size: 25,
                              ),
                              onPressed: onRefresh,
                            ),
                            IconButton(
                              icon: const Icon(
                                CupertinoIcons.trash,
                                color: Colors.white,
                                size: 25,
                              ),
                              onPressed: onDelete,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.flag,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          category,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
