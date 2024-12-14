import 'package:flutter/material.dart';

class UserPreferencesScreen extends StatefulWidget {
  const UserPreferencesScreen({Key? key}) : super(key: key);

  @override
  State<UserPreferencesScreen> createState() => _UserPreferencesScreenState();
}

class _UserPreferencesScreenState extends State<UserPreferencesScreen> {
  // State for Distance Format
  String _distanceFormat = "miles";

  // State for Time Format
  String _timeFormat = "12-hour";

  // State for Number of Challenges
  int _numberOfChallenges = 5;

  // State for Challenge Difficulty
  final Map<String, bool> _challengeDifficulty = {
    "Easy": true,
    "Medium": true,
    "Hard": true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User Preferences",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          // Distance Format
          const Text(
            "Distance Format",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          RadioListTile<String>(
            value: "miles",
            groupValue: _distanceFormat,
            onChanged: (value) {
              setState(() {
                _distanceFormat = value!;
              });
            },
            title: const Text(
              "Miles",
              style: TextStyle(fontSize: 18.0),
            ),
            contentPadding: EdgeInsets.zero,
          ),
          RadioListTile<String>(
            value: "km",
            groupValue: _distanceFormat,
            onChanged: (value) {
              setState(() {
                _distanceFormat = value!;
              });
            },
            title: const Text(
              "Km",
              style: TextStyle(fontSize: 18.0),
            ),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 15),

          // Time Format
          const Text(
            "Time Format",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          RadioListTile<String>(
            value: "12-hour",
            groupValue: _timeFormat,
            onChanged: (value) {
              setState(() {
                _timeFormat = value!;
              });
            },
            title: const Text(
              "12-hour",
              style: TextStyle(fontSize: 18.0),
            ),
            contentPadding: EdgeInsets.zero,
          ),
          RadioListTile<String>(
            value: "24-hour",
            groupValue: _timeFormat,
            onChanged: (value) {
              setState(() {
                _timeFormat = value!;
              });
            },
            title: const Text(
              "24-hour",
              style: TextStyle(fontSize: 18.0),
            ),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 15),

          // Number of Challenges
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Number of Challenges",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: DropdownButton<int>(
                  value: _numberOfChallenges,
                  onChanged: (value) {
                    setState(() {
                      _numberOfChallenges = value!;
                    });
                  },
                  items: [5, 10, 12, 15].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text("$value"),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Challenge Difficulty
          const Text(
            "Challenge Difficulty",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          Column(
            children: _challengeDifficulty.keys.map((difficulty) {
              return CheckboxListTile(
                title: Text(difficulty),
                value: _challengeDifficulty[difficulty],
                activeColor: Colors.deepPurple,
                onChanged: (value) {
                  setState(() {
                    _challengeDifficulty[difficulty] = value!;
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
