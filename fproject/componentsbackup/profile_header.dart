import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Profile Image Placeholder
        CircleAvatar(
          radius: 44,
          backgroundColor: Colors.grey[300],
          child: Icon(Icons.person, size: 40, color: Colors.grey[600]),
        ),
        SizedBox(width: 20),
        // User Info
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [  
                Text(
                  "User 1",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                Icon(Icons.flag, color: Colors.blue, size: 20),
              ],
            ),
            Text("Level 4", style: TextStyle(fontSize: 16)),
            SizedBox(height: 5),
            // Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 150,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                      ),
                    ),
                    Container(
                      width: 90, // Progress width
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text("6/10 Challenges", style: TextStyle(fontSize: 14)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
