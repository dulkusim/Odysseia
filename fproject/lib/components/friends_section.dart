import 'package:flutter/material.dart';
import 'section_header.dart';

class FriendsSection extends StatelessWidget {
  final VoidCallback onShowAllPressed;

  const FriendsSection({Key? key, required this.onShowAllPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: "Friends", onShowAllPressed: onShowAllPressed),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            return CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, color: Colors.grey),
            );
          }),
        ),
      ],
    );
  }
}
