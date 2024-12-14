import 'package:flutter/material.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Account Settings",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
              title: const Text(
                "Username",
                style: TextStyle(fontSize: 18),
              ),
              subtitle: const Text(
                "User123",
                style: TextStyle(fontSize: 16),
              ),
              leading: const Icon(Icons.person, size: 35),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
              title: const Text(
                "Email",
                style: TextStyle(fontSize: 18),
              ),
              subtitle: const Text(
                "user@example.com",
                style: TextStyle(fontSize: 16),
              ),
              leading: const Icon(Icons.email, size: 30),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
              title: const Text(
                "Language",
                style: TextStyle(fontSize: 18),
              ),
              subtitle: const Text(
                "English",
                style: TextStyle(fontSize: 16),
              ),
              leading: const Icon(Icons.language, size: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
