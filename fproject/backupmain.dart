import 'package:flutter/material.dart';
import 'package:fproject/components/city_image.dart';
import 'lib/components/search_bar.dart'; // Import the reusable widget
import 'lib/components/image_card.dart'; // Import the reusable widget
import 'package:hugeicons/hugeicons.dart';


void main() {
  runApp(OdysseiaApp());
}

class OdysseiaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // To track the selected navigation item

  // A list of widgets to display for each tab
  final List<Widget> _screens = [
    SingleChildScrollView(child: BasedOnPreferencesText()), // Home screen
    Center(child: Text("Challenges Screen", style: TextStyle(fontSize: 24))), // Battles screen
    Center(child: Text("Map Screen", style: TextStyle(fontSize: 24))), // Map screen
    Center(child: Text("Profile Screen", style: TextStyle(fontSize: 24))), // Profile screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0 ? OdysseiaAppBar() : null, // Show app bar only on the first screen
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
            BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
            ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shield), // Placeholder for battles icon
            label: 'Challenges',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map, size: 25),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.black, // Active icon color
        unselectedItemColor: Colors.grey, // Inactive icon color
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
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
          height: 3.0,
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
        SizedBox(height: 30),
        DokimastikoSection()
      ],
    );
  }
}

class DokimastikoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Dokimi:',
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
                CityCard(cityName: "Dokimi1"),
                CityCard(cityName: "Dokimi2"),
                CityCard(cityName: "Dokimi3"),
                CityCard(cityName: "Dokimi4"),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

class CityPageInfo extends StatelessWidget {
  final String cityName;

  const CityPageInfo({required this.cityName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: Text(
          cityName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: TextButton.icon(
              onPressed: () {
                print('Begin button pressed for $cityName');
              },
              label: Text(
                'Begin',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              icon: Icon(
                HugeIcons.strokeRoundedSword03,
                color: Colors.white,
                size: 30,
              ),
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF11366D), // Dark blue
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(thickness: 1.0, height: 1.0, color: Colors.black),
        ),
      ),
      body: CityImageSection(),
    );
  }
}

class CityImageSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: CityPlaceholder(),
                );
              }),
            ),
          ),
        ),
        SizedBox(height: 20),
        CityPageDescription()
      ],
    );
  }
}

class CityPageDescription extends StatefulWidget {
  @override
  CityPageDescState createState() => CityPageDescState();
}

class CityPageDescState extends State<CityPageDescription> {
  bool isExpanded = false; // Tracks if the description is expanded

  final String defaultDescription =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
      "Phasellus volutpat turpis nec tortor auctor, id bibendum est "
      "congue. Aenean accumsan tellus eget lectus pretium, in facilisis "
      "leo tincidunt. Ut vitae bibendum nunc. Nulla facilisi. "
      "Suspendisse potenti. Mauris ut aliquam augue.";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isExpanded
                ? defaultDescription
                : "${defaultDescription.substring(0, 130)}...", // Shortened description
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded; // Toggle expansion state
              });
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
              isExpanded ? "Read Less" : "Read More",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

