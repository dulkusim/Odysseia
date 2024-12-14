import 'package:flutter/material.dart';
import 'package:fproject/screens/account_settings_screen.dart';
import 'package:fproject/screens/notifications_screen.dart';
import 'package:fproject/screens/user_preferences_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
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
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        children: [
          ListTile(
        title: const Text(
          "Account",
          style: TextStyle(fontSize: 22.0),
        ),
        leading: const Icon(Icons.person, size: 30.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AccountSettingsScreen()),
          );
        },
          ),
          const Divider(color: Colors.grey),
          ListTile(
        title: const Text(
          "Notifications",
          style: TextStyle(fontSize: 22.0),
        ),
        leading: const Icon(Icons.notifications, size: 30.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
          );
        },
          ),
          const Divider(color: Colors.grey),
          ListTile(
        title: const Text(
          "User Preferences",
          style: TextStyle(fontSize: 22.0),
        ),
        leading: const Icon(Icons.settings, size: 30.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UserPreferencesScreen()),
          );
        },
          ),
          const Divider(color: Colors.grey),
          ListTile(
        title: const Text(
          "Rate this app",
          style: TextStyle(fontSize: 22.0),
        ),
        leading: const Icon(Icons.star, size: 30.0),
        onTap: () {
          // Implement rate app logic
        },
          ),
          const Divider(color: Colors.grey),
          ListTile(
        title: const Text(
          "Log out",
          style: TextStyle(fontSize: 22.0),
        ),
        leading: const Icon(Icons.logout, size: 30.0),
        onTap: () {
          // Implement log out logic
        },
          ),
        const Divider(color: Colors.grey),
        ],
      ),
    );
  }
}
