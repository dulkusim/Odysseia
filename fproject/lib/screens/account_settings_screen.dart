import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  AccountSettingsScreenState createState() => AccountSettingsScreenState();
}

class AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _usernameController = TextEditingController();
  String? _email;
  String? _profilePictureUrl;
  File? _newProfilePicture;

  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final snapshot =
            await _firestore.collection('Users').doc(user.uid).get();
        if (snapshot.exists) {
          final userData = snapshot.data();
          setState(() {
            _usernameController.text = userData?['username'] ?? '';
            _email = user.email;
            _profilePictureUrl = userData?['profilepicture'];
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load user data.';
      });
    }
  }

  Future<void> _updateUsername() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('Users').doc(user.uid).update({
          'username': _usernameController.text.trim(),
        });
        setState(() {
          _successMessage = 'Username updated successfully.';
          _errorMessage = null; // Clear any previous errors
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to update username.';
      });
    }
  }

  Future<void> _changeProfilePicture() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _newProfilePicture = File(pickedFile.path);
        });

        // Update the Firestore or Firebase Storage here if necessary
        setState(() {
          _successMessage = 'Profile picture updated successfully.';
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to update profile picture.';
      });
    }
  }

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
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.red.withOpacity(0.1),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              if (_successMessage != null)
                Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.green.withOpacity(0.1),
                  child: Text(
                    _successMessage!,
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              const SizedBox(height: 20),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _newProfilePicture != null
                          ? FileImage(_newProfilePicture!)
                          : (_profilePictureUrl != null && _profilePictureUrl!.isNotEmpty
                              ? NetworkImage(_profilePictureUrl!)
                              : const AssetImage('assets/default_avatar.png'))
                              as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.black),
                        onPressed: _changeProfilePicture,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.purple.shade200,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Username',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.black),
                      onPressed: _updateUsername,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.purple.shade200,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Email',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      _email ?? '',
                      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
