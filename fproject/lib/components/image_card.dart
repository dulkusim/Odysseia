import 'package:flutter/material.dart';

class CityCard extends StatelessWidget {
  final String cityName;
  final String? imageUrl;

  const CityCard({required this.cityName, this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0), // Adds spacing to the right
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              width: 117,
              height: 80,
              color: Colors.grey.shade300,
              child: imageUrl != null
                  ? Image.network(imageUrl!, fit: BoxFit.cover)
                  : Icon(Icons.image, size: 40, color: Colors.grey),
            ),
          ),
          SizedBox(height: 8),
          Text(
            cityName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
