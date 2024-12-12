import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Handle more options
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3.0),
          child: Container(
            color: Colors.black,
            height: 3.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _ProfileHeader(),
            const SizedBox(height: 30),
            _Section(
              title: 'Awards',
              onShowAllPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AwardsScreen()));
              },
              itemCount: 6,
            ),
            const SizedBox(height: 30),
            _Section(
              title: 'Cities',
              onShowAllPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => CitiesScreen()));
              },
              itemCount: 6,
            ),
            const SizedBox(height: 30),
            _Section(
              title: 'Friends',
              onShowAllPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => FriendsScreen()));
              },
              itemCount: 6,
            ),
            const SizedBox(height: 30),
            _GallerySection(
              onShowAllPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => GalleryScreen()));
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Profile avatar
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey[300],
          child: Icon(Icons.person, size: 50, color: Colors.grey[700]),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Username',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Level X',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              // Progress bar for challenges
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 0.6, // Example value
                  backgroundColor: Colors.grey[300],
                  color: Colors.blue,
                  minHeight: 8.0,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'X/Y Challenges',
                style: TextStyle(fontSize: 14.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final VoidCallback onShowAllPressed;
  final int itemCount;

  const _Section({
    Key? key,
    required this.title,
    required this.onShowAllPressed,
    required this.itemCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: title, onShowAllPressed: onShowAllPressed),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(itemCount, (index) {
              return Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _GallerySection extends StatelessWidget {
  final VoidCallback onShowAllPressed;

  const _GallerySection({Key? key, required this.onShowAllPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Gallery', onShowAllPressed: onShowAllPressed),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(4, (index) {
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onShowAllPressed;

  const _SectionHeader({
    Key? key,
    required this.title,
    required this.onShowAllPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
          ),
        ),
        TextButton(
          onPressed: onShowAllPressed,
          child: const Text(
            'Show all',
            style: TextStyle(fontSize: 16.0, color: Colors.blue),
          ),
        ),
      ],
    );
  }
}

// Placeholder screens for navigation
class AwardsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text('My Awards')));
}

class CitiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text('My Cities')));
}

class FriendsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text('My Friends')));
}

class GalleryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text('Gallery')));
}
