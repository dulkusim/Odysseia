import 'package:flutter/material.dart';
import '../lib/components/image_card.dart'; // Import the reusable widget

class DokimastikoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Your Friends Visited:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
            ),
          ),
        ),
        SizedBox(height: 9),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CityCard(cityName: "Milan"),
                CityCard(cityName: "Barcelona"),
                CityCard(cityName: "Thessaloniki"),
                CityCard(cityName: "Warsaw"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}