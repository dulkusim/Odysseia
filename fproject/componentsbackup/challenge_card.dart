import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class ChallengeCard extends StatelessWidget {
  final String title; // Challenge name
  final String category; // Flag text

  const ChallengeCard({
    Key? key,
    required this.title,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 14.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          color: Color.fromARGB(255, 119, 17, 17), // Background color (Brownish red)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Red Border
            Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
              child: Container(
                height: 150, // Smaller image height
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromARGB(255, 119, 17, 17), // Red border color
                  ),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
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
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 0, 10.0, 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Refresh Button Row
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
                      // Refresh Button
                      IconButton(
                        icon: Icon(CupertinoIcons.arrow_2_circlepath, color: Colors.white, size: 25),
                        onPressed: () {
                          print('Refresh button pressed');
                        },
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
