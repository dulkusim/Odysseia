import 'package:flutter/material.dart';
import 'lib/components/search_bar.dart'; // Import the reusable widget
import 'lib/components/image_card.dart'; // Import the reusable widget

void main() {
  runApp(OdysseiaApp());
}

class OdysseiaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: OdysseiaAppBar(),
        body: SingleChildScrollView(
          child: BasedOnPreferencesText(),
        ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15), // Add some spacing at the top
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Based on your preferences',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
              IconButton(
                icon: Icon(Icons.filter_alt),
                iconSize: 30.0,
                onPressed: () {
                  // Handle filter button press
                  print("Filter button pressed");
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CityCard(cityName: "Oslo"),
                CityCard(cityName: "Bansko"),
                CityCard(cityName: "Bolzano"),
                CityCard(cityName: "Bucharest"), // Fourth city added
              ],
            ),
          ),
        ),
        SizedBox(height: 30), // Add some spacing between sections

        // "Weekend trips" section
        WeekendTripsSection(),
      ],
    );
  }
}

class WeekendTripsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Weekend trips:',
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
                CityCard(cityName: "Volos"),
                CityCard(cityName: "Nafplio"),
                CityCard(cityName: "Aegina"),
                CityCard(cityName: "Kalamata"),
              ],
            ),
          ),
        ),
        SizedBox(height: 30),

        // "Popular Destinations" section
        PopularDestinationsSection(),
      ],
    );
  }
}

class PopularDestinationsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Popular Destinations:',
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
                CityCard(cityName: "Paris"),
                CityCard(cityName: "Los Angeles"),
                CityCard(cityName: "Madrid"),
                CityCard(cityName: "Rome"),
              ],
            ),
          ),
        ),
        SizedBox(height: 30),

        // "Friends visited" section
        FriendsVisitedSection(),
      ],
    );
  }
}

class FriendsVisitedSection extends StatelessWidget {
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

