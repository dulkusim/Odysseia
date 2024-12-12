import 'package:flutter/material.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
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
          ListTile(
            title: const Text("Username"),
            subtitle: const Text("User123"),
          ),
          ListTile(
            title: const Text("Email"),
            subtitle: const Text("user@example.com"),
          ),
          ListTile(
            title: const Text("Language"),
            subtitle: const Text("English"),
          ),
        ],
      ),
    );
  }
}
