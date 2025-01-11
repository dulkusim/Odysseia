import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendsSection extends StatelessWidget {
  final VoidCallback? onShowAllPressed;

  const FriendsSection({Key? key, this.onShowAllPressed}) : super(key: key);

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with "Show all" button
        Row(
          children: [
            const Expanded(
              child: Text(
                "Friends",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            if (onShowAllPressed != null)
              TextButton(
                onPressed: onShowAllPressed,
                child: const Text(
                  "Show all",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
          ],
        ),

        // Display Friends List
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(currentUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final friends = List<String>.from(userData['friends'] ?? []);

            if (friends.isEmpty) {
              return const Center(
                child: Text(
                  "No friends yet",
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchFriendsData(friends),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final friendsData = snapshot.data!;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: friendsData.map((friend) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: friend['profilepicture'].isNotEmpty
                                  ? NetworkImage(friend['profilepicture'])
                                  : const AssetImage('assets/default_avatar.png')
                                      as ImageProvider,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              friend['username'] ?? 'Unknown',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Future<List<Map<String, dynamic>>> _fetchFriendsData(List<String> friendIds) async {
    try {
      final friendSnapshots = await Future.wait(
        friendIds.map((id) =>
            FirebaseFirestore.instance.collection('Users').doc(id).get()),
      );

      return friendSnapshots.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'username': data['username'] ?? 'Unknown',
          'profilepicture': data['profilepicture'] ?? '',
        };
      }).toList();
    } catch (e) {
      print("Error fetching friends data: $e");
      return [];
    }
  }
}
