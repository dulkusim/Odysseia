import 'package:flutter/material.dart';

class UserPreferencesScreen extends StatelessWidget {
  const UserPreferencesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Preferences"),
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
        padding: const EdgeInsets.all(16.0),
        children: [
          const ListTile(
            title: Text("Distance Format"),
            subtitle: Text("Miles/Km"),
          ),
          const ListTile(
            title: Text("Time Format"),
            subtitle: Text("12-hour/24-hour"),
          ),
          const ListTile(
            title: Text("Number of Challenges"),
            subtitle: Text("3"),
          ),
          const ListTile(
            title: Text("Challenge Difficulty"),
            subtitle: Text("Easy, Medium, Hard"),
          ),
        ],
      ),
    );
  }
}
