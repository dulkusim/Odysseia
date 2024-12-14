import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ChallengeCardReal extends StatelessWidget {
  final String title; // Challenge name
  final String category; // Flag text

  const ChallengeCardReal({
    Key? key,
    required this.title,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 14.0,
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 119, 17, 17), // Background color (Brownish red)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Red Border and Overlayed Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
              child: Stack(
                children: [
                  Container(
                    height: 150, // Image height
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromARGB(255, 119, 17, 17), // Red border color
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0), // Optional rounded corners
                      child: Container(
                        color: Colors.grey[300], // Placeholder color
                        child: Center(
                          child: Icon(
                            Icons.image,
                            size: 50.0,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Camera and Map Buttons
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Row(
                      children: [
                        // Camera Button
                        IconButton(
                          icon: Icon(
                            CupertinoIcons.camera,
                            color: Colors.black,
                            size: 25,
                          ),
                          onPressed: () {
                            print("Camera button pressed");
                          },
                          color: Colors.black.withOpacity(0.7), // Optional icon background
                        ),
                        // Map Button
                        IconButton(
                          icon: Icon(
                            CupertinoIcons.map,
                            color: Colors.black,
                            size: 25,
                          ),
                          onPressed: () {
                            print("Map button pressed");
                          },
                          color: Colors.black.withOpacity(0.7), // Optional icon background
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 0, 10.0, 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Buttons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Challenge Title
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      // Action Buttons (Refresh and Trash Bin)
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              CupertinoIcons.arrow_2_circlepath,
                              color: Colors.white,
                              size: 25,
                            ),
                            onPressed: () {
                              print('Refresh button pressed');
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              CupertinoIcons.trash,
                              color: Colors.white,
                              size: 25,
                            ),
                            onPressed: () {
                              print('Trash button pressed');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Category Row
                  Row(
                    children: [
                      Icon(
                        Icons.flag,
                        color: Colors.white,
                        size: 18.0,
                      ),
                      const SizedBox(width: 5.0),
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 14.0,
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
    );
  }
}
