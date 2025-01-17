import 'package:flutter/material.dart';
import 'section_header.dart';

class GallerySection extends StatelessWidget {
  final VoidCallback onShowAllPressed;

  const GallerySection({Key? key, required this.onShowAllPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: "Gallery", onShowAllPressed: onShowAllPressed),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(3, (index) {
            return Container(
              width: 110,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.image, color: Colors.grey),
            );
          }),
        ),
      ],
    );
  }
}
