import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'challenge_card2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengesScreen extends StatelessWidget {
  final String cityName;

  const ChallengesScreen({required this.cityName, Key? key}) : super(key: key);

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
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Handle menu actions
              print("More options pressed");
            },
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
              SizedBox(height: 10), // Padding from the black line divider
              // Profile and Buttons Row
              Row(
                children: [
                  // Profile Image
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
                  // Invite Button
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
                  SizedBox(width: 20), // Added gap between buttons
                  // Battle Button
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
                      minimumSize: Size(100, 50), // Set minimum size for buttons
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              // Challenges Progress Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: Container(
                  width: double.infinity,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black, // Border color
                      width: 2.0, // Border width
                    ),
                  ),
                  child: ClipRRect(
                    child: LinearProgressIndicator(
                      value: 0.5, // 50% completion
                      backgroundColor: Colors.grey.shade300,
                      color: Color.fromARGB(255, 67, 177, 17), // Dark blue
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ChallengesText(cityName: cityName), // Use the new widget here
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
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Challenges (20)",
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
        DisplayChallengeCardsReal(cityName: cityName),
      ],
    );
  }
}

class DisplayChallengeCardsReal extends StatelessWidget {
  final String cityName;

  const DisplayChallengeCardsReal({required this.cityName, Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> fetchChallenges(String cityName) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('cities')
          .doc(cityName.toLowerCase())
          .collection('challenges')
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching challenges for $cityName: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchChallenges(cityName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No challenges available."));
        } else {
          final challenges = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: challenges.length,
            itemBuilder: (context, index) {
              final challenge = challenges[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ChallengeCardReal(
                  title: challenge['name'],
                  category: challenge['category'],
                  imageUrl: challenge['image'], // Display the challenge image
                ),
              );
            },
          );
        }
      },
    );
  }
}
