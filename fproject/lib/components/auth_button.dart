import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const AuthButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: Colors.grey.shade400),
        ),
        padding: EdgeInsets.symmetric(vertical: 12),
      ),
      icon: Icon(icon, color: Colors.blue),
      label: Text(
        label,
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
    );
  }
}
