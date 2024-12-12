import 'package:flutter/material.dart';
import 'section_header.dart';

class AwardsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: "Awards"),
        SizedBox(height: 10),   
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            return CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.emoji_events, color: Colors.grey[600]),
            );
          }),
        ),
      ],
    );
  }
}
