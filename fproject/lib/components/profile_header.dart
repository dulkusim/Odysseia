import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(
        child: Text(
          "No user logged in",
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final profilePicture = userData['profilepicture'] ?? '';
        final username = userData['username'] ?? 'Unknown User';

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 44,
              backgroundImage: profilePicture.isNotEmpty
                  ? NetworkImage(profilePicture)
                  : const AssetImage('assets/default_avatar.png')
                      as ImageProvider,
            ),
            const SizedBox(width: 20),
            // User Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                // Optional: Add a subtitle or additional user info
                Text(
                  "Level 4",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 5),
                // Progress Bar (Example for challenges progress)
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
                          width: 90, // Adjust progress width dynamically if needed
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "6/10 Challenges",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
