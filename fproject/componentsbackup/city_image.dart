import 'package:flutter/material.dart';

class CityPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: AssetImage('assets/images/placeholder.jpg'), // Replace with your asset path
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}