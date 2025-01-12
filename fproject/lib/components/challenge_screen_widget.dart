import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'challenge_card2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChallengesScreen extends StatelessWidget {
  final String cityName;

  const ChallengesScreen({required this.cityName, Key? key}) : super(key: key);

  Future<void> _endOrCompleteTrip(BuildContext context, String action) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = FirebaseFirestore.instance.collection('Users').doc(userId);

    try {
      // Update Firestore to remove the current city
      await userDoc.update({'current_city': ''});
      // Add the city to the visitedcities list
      await userDoc.update({
        'visitedcities': FieldValue.arrayUnion([cityName])
      });
    } catch (e) {
      print("Error ending trip: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            cityName,
            style: TextStyle(fontSize: 25),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Complete Trip') {
                _endOrCompleteTrip(context, 'completed');
              } else if (value == 'End Trip') {
                _endOrCompleteTrip(context, 'ended');
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'Complete Trip',
                child: Text('Complete Trip'),
              ),
              PopupMenuItem(
                value: 'End Trip',
                child: Text('End Trip'),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0),
          child: Divider(
            thickness: 3.0,
            height: 1.0,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.grey.shade200,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.grey.shade200,
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      print("Invite button pressed");
                    },
                    icon: Icon(Icons.add, color: Colors.white, size: 30),
                    label: Text(
                      'Invite',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 13, 54, 84),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      print("Battle button pressed");
                    },
                    icon: Icon(HugeIcons.strokeRoundedSword03,
                        size: 30, color: Colors.white),
                    label: Text(
                      'Battle',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 13, 54, 84),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
                      minimumSize: Size(100, 50),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: Container(
                  width: double.infinity,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  child: ClipRRect(
                    child: LinearProgressIndicator(
                      value: 0.5,
                      backgroundColor: Colors.grey.shade300,
                      color: Color.fromARGB(255, 67, 177, 17),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ChallengesText(cityName: cityName),
            ],
          ),
        ),
      ),
    );
  }
}

class ChallengesText extends StatelessWidget {
  final String cityName;

  const ChallengesText({required this.cityName, Key? key}) : super(key: key);

  Future<int> fetchNumberOfChallenges() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final userDoc = FirebaseFirestore.instance.collection('Users').doc(userId);
      final userSnapshot = await userDoc.get();

      // Fetch the number of challenges from Firestore, default to 10 if not set
      return userSnapshot.data()?['challenges'] ?? 10;
    } catch (e) {
      print("Error fetching number of challenges: $e");
      return 10; // Default value
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: fetchNumberOfChallenges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Center(child: Text("Error loading challenges."));
        }

        final numberOfChallenges = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Challenges ($numberOfChallenges)",
              style: TextStyle(fontSize: 25, color: Colors.black),
            ),
            DisplayChallengeCardsReal(cityName: cityName),
          ],
        );
      },
    );
  }
}

class DisplayChallengeCardsReal extends StatefulWidget {
  final String cityName;

  const DisplayChallengeCardsReal({required this.cityName, Key? key}) : super(key: key);

  @override
  State<DisplayChallengeCardsReal> createState() => _DisplayChallengeCardsRealState();
}

class _DisplayChallengeCardsRealState extends State<DisplayChallengeCardsReal> {
  List<Map<String, dynamic>> challenges = [];
  int refreshLimit = 0;

  @override
  void initState() {
    super.initState();
    fetchChallenges();
  }

Future<void> fetchChallenges() async {
  try {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = FirebaseFirestore.instance.collection('Users').doc(userId);
    final userSnapshot = await userDoc.get();

    final numberOfChallenges = userSnapshot.data()?['challenges'] ?? 10;
    refreshLimit = 19 - (numberOfChallenges as int);

    final snapshot = await FirebaseFirestore.instance
        .collection('cities')
        .doc(widget.cityName.toLowerCase())
        .collection('challenges')
        .limit(numberOfChallenges)
        .get();

    setState(() {
      challenges = snapshot.docs.map((doc) {
        final data = doc.data();
        final location = data['location']; // Retrieve the GeoPoint
        return {
          'name': data['name'],
          'category': data['category'],
          'image': data['image'],
          'location': location != null
              ? {
                  'latitude': location.latitude,
                  'longitude': location.longitude,
                }
              : null, // Convert GeoPoint to a map
        };
      }).toList();
    });
  } catch (e) {
    print('Error fetching challenges for ${widget.cityName}: $e');
  }
}

  void onRefresh(int index) async {
    if (refreshLimit <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No more refreshes allowed!")),
      );
      return;
    }

    try {
      final allChallengesSnapshot = await FirebaseFirestore.instance
          .collection('cities')
          .doc(widget.cityName.toLowerCase())
          .collection('challenges')
          .get();

      final allChallenges = allChallengesSnapshot.docs.map((doc) => doc.data()).toList();

      // Exclude the current challenges to ensure a new one is picked
      final remainingChallenges = allChallenges.where((challenge) {
        return !challenges.contains(challenge);
      }).toList();

      if (remainingChallenges.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No more new challenges available!")),
        );
        return;
      }

      // Select the next new challenge from the remaining ones
      final newChallenge = remainingChallenges[refreshLimit % remainingChallenges.length];

      setState(() {
        challenges[index] = newChallenge; // Replace the challenge at the given index
        refreshLimit--; // Decrease the refresh limit
      });
    } catch (e) {
      print("Error refreshing challenge: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to refresh challenge.")),
      );
    }
  }

  void onDelete(int index) {
    setState(() {
      challenges.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        final challenge = challenges[index];
        return Column(
          children: [
            ChallengeCardReal(
              title: challenge['name'],
              category: challenge['category'],
              imageUrl: challenge['image'],
              location: challenge['location'], // Pass the location to the card
              onRefresh: () => onRefresh(index),
              onDelete: () => onDelete(index),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }
}
