import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ChallengeCardReal extends StatelessWidget {
  final String title; // Challenge name
  final String category; // Challenge category
  final String? imageUrl; // Image for the challenge
  final VoidCallback onRefresh; // Callback for refresh button
  final VoidCallback onDelete; // Callback for delete button

  const ChallengeCardReal({
    Key? key,
    required this.title,
    required this.category,
    this.imageUrl,
    required this.onRefresh,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0), // Consistent padding
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 2, 6, 109), // Background color
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with overlay buttons
              Container(
                height: 200, // Image height
                width: double.infinity, // Full width
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                ),
                child: Stack(
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                      child: imageUrl != null
                          ? Image.network(
                              imageUrl!,
                              width: double.infinity, // Full width
                              height: 200, // Ensure height consistency
                              fit: BoxFit.cover, // Ensures the image fills the space
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.error, color: Colors.red, size: 50),
                              ),
                            )
                          : Container(
                              color: Colors.grey[300],
                              child: Center(
                                child: Icon(Icons.image, size: 50.0, color: Colors.grey[500]),
                              ),
                            ),
                    ),
                    // Camera and Map Buttons
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Row(
                        children: [
                          // Camera Button with Semi-Transparent Background
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4), // Semi-transparent black background
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
                          const SizedBox(width: 8), // Spacing between buttons
                          // Map Button with Semi-Transparent Background
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4), // Semi-transparent black background
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                CupertinoIcons.map,
                                color: Colors.white,
                                size: 25,
                              ),
                              onPressed: () {
                                print("Map button pressed");
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Title and category with action buttons
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 5.0, bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Action Buttons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Challenge Title
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
                        // Refresh and Trash Buttons
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
                    const SizedBox(height: 5.0),
                    // Category Row
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
