import 'package:flutter/material.dart';
import 'components/search_bar.dart'; // Import the reusable widget

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

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _isSearching
          ? mySearchBar(
              onSearch: (value) {
                print('Search input: $value'); // Handle search logic here
              },
              onClose: () {
                setState(() {
                  _isSearching = false;
                });
              },
            )
          : Text(
            'Odysseia',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
      actions: [
        if (!_isSearching)
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = true;
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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Based on your preferences',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.0, // Adjust font size as needed
            ),
          ),
          IconButton(
            icon: Icon(Icons.filter_alt),
            iconSize: 30.0, // Adjust icon size as needed
            onPressed: () {
              // Handle filter button press
              print("Filter button pressed");
            },
          ),
        ],
      ),
    );
  }
}

