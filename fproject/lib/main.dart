import 'package:flutter/material.dart';

void main() {
  runApp(OdysseiaApp());
}

class OdysseiaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: OdysseiaAppBar(),
        body: BasedOnPreferencesText(),
      ),
    );
  }
}

class OdysseiaAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  OdysseiaAppBarState createState() => OdysseiaAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 4.0);
}

class OdysseiaAppBarState extends State<OdysseiaAppBar> {
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                // Handle search logic here
                print('Search input: $value');
              },
            )
          : Text('Odysseia'),
      actions: [
        IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchController.clear(); // Clear input on exit
              }
            });
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(4.0),
        child: Container(
          color: Colors.black,
          height: 4.0,
        ),
      ),
    );
  }
}

class BasedOnPreferencesText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'Based on your preferences',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
