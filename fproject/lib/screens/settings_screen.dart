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
            title: const Text("Account"),
            leading: const Icon(Icons.person),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AccountSettingsScreen()),
              );
            },
          ),
          ListTile(
            title: const Text("Notifications"),
            leading: const Icon(Icons.notifications),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
          ListTile(
            title: const Text("User Preferences"),
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserPreferencesScreen()),
              );
            },
          ),
          ListTile(
            title: const Text("Rate this app"),
            leading: const Icon(Icons.star),
            onTap: () {
              // Implement rate app logic
            },
          ),
          ListTile(
            title: const Text("Log out"),
            leading: const Icon(Icons.logout),
            onTap: () {
              // Implement log out logic
            },
          ),
        ],
      ),
    );
  }
}
