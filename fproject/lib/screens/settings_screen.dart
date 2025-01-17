// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fproject/screens/account_settings_screen.dart';
import 'package:fproject/screens/notifications_screen.dart';
import 'package:fproject/screens/user_preferences_screen.dart';
import 'package:fproject/main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
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
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        children: [
          // Account Settings
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

          // Notifications Settings
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

          // User Preferences
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

          // Rate App Placeholder
          ListTile(
            title: const Text(
              "Rate this app",
              style: TextStyle(fontSize: 22.0),
            ),
            leading: const Icon(Icons.star, size: 30.0),
            onTap: () {
              // Implement rate app logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Rate app functionality is not implemented yet.")),
              );
            },
          ),
          const Divider(color: Colors.grey),

          // Logout
          ListTile(
            title: const Text(
              "Log out",
              style: TextStyle(fontSize: 22.0),
            ),
            leading: const Icon(Icons.logout, size: 30.0),
            onTap: () async {
              try {
                // Log out the user
                await FirebaseAuth.instance.signOut();

                // Navigate to the sign-in page
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                  (route) => false, // Remove all previous routes
                );
              } catch (e) {
                // Handle any errors during logout
                print("Error during sign out: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error logging out. Please try again.")),
                );
              }
            },
          ),
          const Divider(color: Colors.grey),
        ],
      ),
    );
  }
}
