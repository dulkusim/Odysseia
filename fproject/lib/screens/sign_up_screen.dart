import 'package:flutter/material.dart';
import 'sign_in_screen.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Image.asset(
                'assets/logo.png', // Replace with your logo
                height: 100,
              ),
              SizedBox(height: 20),
              // Tagline
              Text(
                "Where every challenge is a journey",
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              // Facebook Button
              _buildAuthButton(
                label: "Sign up with Facebook",
                icon: Icons.facebook,
                color: Colors.blue.shade800,
                onPressed: () {
                  // Handle Facebook Sign Up
                },
              ),
              SizedBox(height: 15),
              // Google Button
              _buildAuthButton(
                label: "Sign up with Google",
                icon: Icons.g_mobiledata,
                color: Colors.red.shade800,
                onPressed: () {
                  // Handle Google Sign Up
                },
              ),
              SizedBox(height: 15),
              // Email Button
              _buildAuthButton(
                label: "Sign up with Email",
                icon: Icons.email,
                color: Colors.teal,
                onPressed: () {
                  // Handle Email Sign Up
                },
              ),
              SizedBox(height: 20),
              // Link to Sign In
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInScreen()),
                  );
                },
                child: Text(
                  "Already have an account? Sign In",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
