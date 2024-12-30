// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
import 'firebase_options.dart'; // Generated file for Firebase configuration
//import 'package:fproject/components/city_image.dart';
import 'components/search_bar.dart'; // Import the reusable widget
import 'components/image_card.dart'; // Import the reusable widget
import 'components/challenge_card.dart'; // Import the reusable widget
import 'package:hugeicons/hugeicons.dart';
import 'components/profile_header.dart'; // Import the reusable widget
import 'components/awards_section.dart'; // Import the reusable widget
import 'components/cities_section.dart'; // Import the reusable widget
import 'components/friends_section.dart'; // Import the reusable widget
import 'components/gallery_section.dart'; // Import the reusable widget
import 'package:fproject/screens/awards_screen.dart';
import 'package:fproject/screens/cities_screen.dart';
import 'package:fproject/screens/friends_screen.dart';
import 'package:fproject/screens/gallery_screen.dart';
import 'package:fproject/screens/settings_screen.dart';
import 'components/challenge_screen_widget.dart'; // Import the reusable widget
//import 'screens/sign_in_screen.dart'; // Import Sign In Screen
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fproject/screens/map_screen.dart'; 
import 'package:geolocator/geolocator.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is ready
  // Initialize Firebase with configuration
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final PopulateChallengesManual populateChallengesManual = PopulateChallengesManual();

  // Challenges for Athens
List<Map<String, dynamic>> zakynthosChallenges = [
  {
    'name': 'Visit Navagio Beach (Shipwreck Cove)',
    'category': 'Beach',
    'gps_verifiable': true,
    'location': GeoPoint(37.8593, 20.6246),
  },
  {
    'name': 'Explore the Blue Caves',
    'category': 'Nature',
    'gps_verifiable': true,
    'location': GeoPoint(37.9251, 20.7012),
  },
  {
    'name': 'Swim at Porto Limnionas Beach',
    'category': 'Beach',
    'gps_verifiable': true,
    'location': GeoPoint(37.7672, 20.6921),
  },
  {
    'name': 'Admire the view from Bohali Castle',
    'category': 'Sights',
    'gps_verifiable': true,
    'location': GeoPoint(37.7911, 20.9008),
  },
  {
    'name': 'Visit the Byzantine Museum of Zakynthos',
    'category': 'Museums',
    'gps_verifiable': true,
    'location': GeoPoint(37.7819, 20.8957),
  },
  {
    'name': 'Taste the traditional Zakynthian Ladotyri cheese',
    'category': 'Food',
    'gps_verifiable': false,
    'location': null,
  },
  {
    'name': 'Walk along Zakynthos Town Harbor',
    'category': 'Sights',
    'gps_verifiable': true,
    'location': GeoPoint(37.7823, 20.8994),
  },
  {
    'name': 'Take a boat tour to Marathonisi Island (Turtle Island)',
    'category': 'Nature',
    'gps_verifiable': true,
    'location': GeoPoint(37.7194, 20.8948),
  },
  {
    'name': 'Relax at Gerakas Beach',
    'category': 'Beach',
    'gps_verifiable': true,
    'location': GeoPoint(37.7001, 20.9986),
  },
  {
    'name': 'Visit the Church of Agios Dionysios',
    'category': 'Sights',
    'gps_verifiable': true,
    'location': GeoPoint(37.7825, 20.9002),
  },
  {
    'name': 'Enjoy a Zakynthian wine tasting experience',
    'category': 'Food',
    'gps_verifiable': false,
    'location': null,
  },
  {
    'name': 'Explore the Venetian Watchtower at Keri',
    'category': 'Sights',
    'gps_verifiable': true,
    'location': GeoPoint(37.6772, 20.8258),
  },
  {
    'name': 'Take a photo at Mizithres Rocks',
    'category': 'Sights',
    'gps_verifiable': true,
    'location': GeoPoint(37.6603, 20.8207),
  },
  {
    'name': 'Walk through Solomos Square',
    'category': 'Sights',
    'gps_verifiable': true,
    'location': GeoPoint(37.7814, 20.8952),
  },
  {
    'name': 'Discover Askos Stone Park',
    'category': 'Nature',
    'gps_verifiable': true,
    'location': GeoPoint(37.8728, 20.7074),
  },
  {
    'name': 'Try local Mandolato (Nougat)',
    'category': 'Food',
    'gps_verifiable': false,
    'location': null,
  },
  {
    'name': 'Dive at Laganas Beach',
    'category': 'Beach',
    'gps_verifiable': true,
    'location': GeoPoint(37.7286, 20.8721),
  },
  {
    'name': 'Explore the Monastery of Anafonitria',
    'category': 'Sights',
    'gps_verifiable': true,
    'location': GeoPoint(37.8673, 20.6371),
  },
  {
    'name': 'Visit the Water Village Zante',
    'category': 'Parks/Gardens',
    'gps_verifiable': true,
    'location': GeoPoint(37.7983, 20.8221),
  },
  {
    'name': 'Watch the sunset at Keri Lighthouse',
    'category': 'Sights',
    'gps_verifiable': true,
    'location': GeoPoint(37.6784, 20.8302),
  },
];

  // Add challenges for Athens
  await populateChallengesManual.addChallengesForCity("Zakynthos", zakynthosChallenges);
  runApp(const OdysseiaApp());
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  bool _isPasswordHidden = true; // Boolean to toggle password visibility

  Future<void> _signIn() async {
    try {
      // Authenticate user
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Navigate to MainScreen on successful sign-in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found') {
          _errorMessage = 'No user found for this email.';
        } else if (e.code == 'wrong-password') {
          _errorMessage = 'Incorrect password.';
        } else {
          _errorMessage = 'Failed to sign in. Please try again.';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Welcome Back!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Email Text Field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Password Text Field with Show/Hide Icon
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordHidden = !_isPasswordHidden;
                    });
                  },
                ),
              ),
              obscureText: _isPasswordHidden,
            ),
            const SizedBox(height: 10),

            // Error Message
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),

            // Sign In Button
            ElevatedButton(
              onPressed: _signIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 15.0),
              ),
              child: const Text(
                "Sign In",
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),

            // Navigate to Sign Up
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: const Text("Don't have an account? Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  bool _isPasswordHidden = true; // Boolean to toggle password visibility

  Future<void> _signUp() async {
    try {
      // Create user with email and password
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Navigate to Sign-In Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'weak-password') {
          _errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          _errorMessage = 'An account already exists for this email.';
        } else {
          _errorMessage = 'Failed to create account. Please try again.';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Create an Account",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Email Text Field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Password Text Field with Show/Hide Icon
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordHidden = !_isPasswordHidden;
                    });
                  },
                ),
              ),
              obscureText: _isPasswordHidden,
            ),
            const SizedBox(height: 10),

            // Error Message
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),

            // Sign Up Button
            ElevatedButton(
              onPressed: _signUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 15.0),
              ),
              child: const Text(
                "Sign Up",
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),

            // Navigate to Sign In
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              },
              child: const Text("Already have an account? Sign In"),
            ),
          ],
        ),
      ),
    );
  }
}

class OdysseiaApp extends StatelessWidget {
  const OdysseiaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpScreen(), // Start with Sign-Up Screen
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Tracks the selected navigation item

  // Screens corresponding to each tab
  final List<Widget> _screens = [
    HomeScreen(), // Home screen
    ChallengesScreen(cityName: "Athens, Greece"), // Challenges screen
    MapScreen(), // Map screen
    ProfileScreen(), // Profile screen
  ];

  // Bottom Navigation Items
  final List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home, size: 30),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(HugeIcons.strokeRoundedSword03, size: 30), // Challenges icon
      label: 'Challenges',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.map, size: 25), // Map icon
      label: 'Map',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person, size: 30),
      label: 'Profile',
    ),
  ];

  // Handle tab selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: _navItems,
        selectedItemColor: Colors.black, // Active icon color
        unselectedItemColor: Colors.grey, // Inactive icon color
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false; // To track if the search bar is active
  String _searchQuery = ''; // To store the current search query
  List<String> _searchSuggestions = []; // Will hold city names from Firestore
  bool _isLoadingCities = true; // To track loading state

  @override
  void initState() {
    super.initState();
    fetchCities(); // Fetch cities when the widget initializes
  }

  Future<void> fetchCities() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('cities').get();
      setState(() {
        _searchSuggestions = snapshot.docs
            .map((doc) => doc['CityName'] as String)
            .toList(); // Extract city names
        _isLoadingCities = false; // Stop loading
      });
    } catch (e) {
      print('Error fetching cities: $e');
      setState(() {
        _isLoadingCities = false; // Stop loading even if there’s an error
      });
    }
  }

  List<String> get _filteredSuggestions => _searchSuggestions
      .where((item) =>
          item.toLowerCase().startsWith(_searchQuery.toLowerCase()))
      .toList();

  List<int> get _filteredSuggestionIndices => _searchSuggestions
      .asMap()
      .entries
      .where((entry) =>
          entry.value.toLowerCase().startsWith(_searchQuery.toLowerCase()))
      .map((entry) => entry.key)
      .toList();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Odysseia title and search bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: _isSearching
                      ? mySearchBar(
                          onSearch: (value) {
                            setState(() {
                              _searchQuery = value; // Update search query dynamically
                            });
                          },
                          onClose: () {
                            setState(() {
                              _isSearching = false;
                              _searchQuery = '';
                            });
                          },
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Odysseia',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30.0,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.search, size: 30),
                              onPressed: () {
                                setState(() {
                                  _isSearching = true;
                                });
                              },
                            ),
                          ],
                        ),
                ),
                Divider(
                  color: Colors.black,
                  thickness: 2,
                  height: 10,
                ),
                // "Based on your preferences" and its content
                _isLoadingCities
                    ? Center(child: CircularProgressIndicator())
                    : BasedOnPreferencesText(),
              ],
            ),
          ),
        ),
        // Search Suggestions Overlay
        if (_isSearching && _searchQuery.isNotEmpty)
          Positioned(
            top: 80, // Adjust this based on your layout
            left: 0,
            right: 0,
            child: Material(
              elevation: 4.0,
              child: Container(
                color: Colors.white,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredSuggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_filteredSuggestions[index]),
                      onTap: () {
                        // Fetch the correct index from the original database
                        final originalIndex = _filteredSuggestionIndices[index];
                        final selectedCityName =
                            _searchSuggestions[originalIndex];

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CityPageInfo(
                              cityName: selectedCityName, // Pass the correct city name
                            ),
                          ),
                        );

                        setState(() {
                          _isSearching = false;
                          _searchQuery = '';
                        });
                      },
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class BasedOnPreferencesText extends StatefulWidget {
  @override
  BasedOnPreferencesTextState createState() => BasedOnPreferencesTextState();
}

class BasedOnPreferencesTextState extends State<BasedOnPreferencesText> {
  List<String> _selectedPreferences = [];
  List<String> _filteredCities = [];

  @override
  void initState() {
    super.initState();
    _fetchCities(); // Fetch all cities initially
  }

  Future<void> _fetchCities() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('cities').get();
      final cityNames = snapshot.docs.map((doc) => doc['CityName'] as String).toList();

      setState(() {
        _filteredCities = cityNames;
      });
    } catch (e) {
      print("Error fetching cities: $e");
    }
  }

  Future<void> _filterCitiesByPreferences(List<String> preferences) async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('cities').get();
      final cities = snapshot.docs.where((doc) {
        final cityPreferences = doc['Preferences'] as List<dynamic>;
        return preferences.every((preference) => cityPreferences.contains(preference));
      }).map((doc) => doc['CityName'] as String).toList();

      setState(() {
        _filteredCities = cities;
        _selectedPreferences = preferences;
      });
    } catch (e) {
      print("Error filtering cities: $e");
    }
  }

  void _openFilterModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FilterBottomSheet(
          selectedFilters: _selectedPreferences,
          onFiltersApplied: (selectedFilters) {
            Navigator.pop(context); // Close the modal
            _filterCitiesByPreferences(selectedFilters); // Filter cities
          },
        );
      },
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
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
                onPressed: _openFilterModal,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filteredCities.map((cityName) {
                return CityCard(cityName: cityName);
              }).toList(),
            ),
          ),
        ),
        SizedBox(height: 30),
        WeekendTripsSection(),
      ],
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  final List<String> selectedFilters;
  final Function(List<String>) onFiltersApplied;

  const FilterBottomSheet({
    required this.selectedFilters,
    required this.onFiltersApplied,
    Key? key,
  }) : super(key: key);

  @override
  FilterBottomSheetState createState() => FilterBottomSheetState();
}

class FilterBottomSheetState extends State<FilterBottomSheet> {
  final Map<String, bool> _filters = {
    'Wine': false,
    'Sightseeing': false,
    'Rest': false,
    'Nature': false,
    'Beach': false,
    'Nightlife': false,
  };

  @override
  void initState() {
    super.initState();
    for (var filter in widget.selectedFilters) {
      if (_filters.containsKey(filter)) {
        _filters[filter] = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter by Preferences',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 10),
          Column(
            children: _filters.keys.map((filter) {
              return CheckboxListTile(
                title: Text(filter),
                value: _filters[filter],
                onChanged: (bool? value) {
                  setState(() {
                    _filters[filter] = value!;
                  });
                },
              );
            }).toList(),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              final selectedFilters = _filters.entries
                  .where((entry) => entry.value)
                  .map((entry) => entry.key)
                  .toList();
              widget.onFiltersApplied(selectedFilters);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: Center(
              child: Text(
                'Apply Filters',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WeekendTripsSection extends StatefulWidget {
  @override
  WeekendTripsSectionState createState() => WeekendTripsSectionState();
}

class WeekendTripsSectionState extends State<WeekendTripsSection> {
  List<Map<String, dynamic>> _closestCities = [];

  @override
  void initState() {
    super.initState();
    _getClosestCities();
  }

  Future<void> _getClosestCities() async {
    try {
      print("Requesting location...");
      // Request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print("Location permission denied, requesting permission...");
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        print("Location permission granted.");
        // Get user's current location
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        double userLat = position.latitude;
        double userLon = position.longitude;

        print("User's location: Latitude = $userLat, Longitude = $userLon");

        // Fetch city data from Firestore
        print("Fetching city data from Firestore...");
        final snapshot = await FirebaseFirestore.instance.collection('cities').get();

        print("Firestore data fetched. Processing cities...");
        List<Map<String, dynamic>> cities = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'CityName': data['CityName'],
            'Latitude': data['Location'].latitude,
            'Longitude': data['Location'].longitude,
          };
        }).toList();

        print("Cities retrieved from Firestore: ${cities.map((city) => city['CityName']).toList()}");

        // Calculate Euclidean distance and sort by proximity
        cities.sort((a, b) {
          double distanceA = _calculateDistance(userLat, userLon, a['Latitude'], a['Longitude']);
          double distanceB = _calculateDistance(userLat, userLon, b['Latitude'], b['Longitude']);
          return distanceA.compareTo(distanceB);
        });

        // Take the 4 closest cities
        setState(() {
          _closestCities = cities.take(5).toList();
        });

        print("Closest cities: ${_closestCities.map((city) => city['CityName']).toList()}");
      } else {
        print("Location permission not granted.");
      }
    } catch (e) {
      print("Error fetching closest cities: $e");
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    double distance = (lat1 - lat2) * (lat1 - lat2) + (lon1 - lon2) * (lon1 - lon2);
    print("Calculated distance: $distance");
    return distance;
  }

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
              children: _closestCities.map((city) {
                return CityCard(cityName: city['CityName']);
              }).toList(),
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
                CityCard(cityName: "Tokyo"),
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
                CityCard(cityName: "Berlin"),
                CityCard(cityName: "Budapest"),
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
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('cities').doc(cityName.toLowerCase()).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading data."));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("City not found."));
          } else {
            final cityData = snapshot.data!.data() as Map<String, dynamic>;
            final cityImages = List<String>.from(cityData['CityImages'] ?? []);
            final cityDescription = cityData['CityDescription'] ?? "No description available.";

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CityImageSection(cityImages: cityImages),
                  CityPageDescription(description: cityDescription),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class CityImageSection extends StatelessWidget {
  final List<String> cityImages;

  const CityImageSection({required this.cityImages, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: cityImages.map((imageUrl) {
            return Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  width: 150,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey,
                      width: 150,
                      height: 100,
                      child: Icon(Icons.error, color: Colors.red),
                    );
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class CityPageDescription extends StatefulWidget {
  final String description;

  const CityPageDescription({required this.description, Key? key}) : super(key: key);

  @override
  CityPageDescState createState() => CityPageDescState();
}

class CityPageDescState extends State<CityPageDescription> {
  bool isExpanded = false; // Tracks if the description is expanded

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isExpanded ? widget.description : "${widget.description.substring(0, 130)}...",
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

class DisplayChallengeCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(2, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ChallengeCard(title: "Challenge $index", category: "Category $index"),
        );
      }),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
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
            ProfileHeader(),
            const SizedBox(height: 30),
            AwardsSection(
              onShowAllPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AwardsScreen()),
                );
              },
            ),
            const SizedBox(height: 30),
            CitiesSection(
              onShowAllPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CitiesScreen()),
                );
              },
            ),
            const SizedBox(height: 30),
            FriendsSection(
              onShowAllPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FriendsScreen()),
                );
              },
            ),
            const SizedBox(height: 30),
            GallerySection(
              onShowAllPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GalleryScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

/*class PopulateChallengesManual {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addChallengesForCity(String cityName) async {
    try {
      // Predefined challenges for Athens
      List<Map<String, dynamic>> challenges = [
        {'name': 'Visit the Acropolis', 'category': 'Sights'},
        {'name': 'Explore the Parthenon', 'category': 'Sights'},
        {'name': 'Walk through Plaka', 'category': 'Sights'},
        {'name': 'Visit the National Archaeological Museum', 'category': 'Museums'},
        {'name': 'See the Changing of the Guard at Syntagma Square', 'category': 'Statues'},
        {'name': 'Try traditional Souvlaki', 'category': 'Food'},
        {'name': 'Relax at the National Garden of Athens', 'category': 'Parks/Gardens'},
        {'name': 'Taste Greek Baklava', 'category': 'Food'},
        {'name': 'Explore Monastiraki Flea Market', 'category': 'Sights'},
        {'name': 'Visit the Temple of Olympian Zeus', 'category': 'Sights'},
        {'name': 'Enjoy the view from Mount Lycabettus', 'category': 'Sights'},
        {'name': 'Take a stroll through Anafiotika', 'category': 'Sights'},
        {'name': 'See the Statue of Athena Promachos', 'category': 'Statues'},
        {'name': 'Learn history at Benaki Museum', 'category': 'Museums'},
        {'name': 'Watch a play at the Odeon of Herodes Atticus', 'category': 'Sights'},
        {'name': 'Visit the Museum of Cycladic Art', 'category': 'Museums'},
        {'name': 'Have a coffee in Kolonaki', 'category': 'Food'},
        {'name': 'Explore the Panathenaic Stadium', 'category': 'Sights'},
        {'name': 'Take a tour of the Zappeion Hall', 'category': 'Sights'},
        {'name': 'See the Hadrian’s Library', 'category': 'Sights'},
      ];

      // Add challenges to Firestore under the specific city
      for (int i = 0; i < challenges.length; i++) {
        await _firestore
            .collection('cities')
            .doc(cityName.toLowerCase())
            .collection('challenges')
            .doc('challenge_$i')
            .set(challenges[i]);
      }
      print("Challenges added for $cityName.");
    } catch (e) {
      print("Error adding challenges for $cityName: $e");
    }
  }
}
*/

class PopulateChallengesManual {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addChallengesForCity(String cityName, List<Map<String, dynamic>> challenges) async {
    try {
      // Add challenges to Firestore under the specific city
      for (int i = 0; i < challenges.length; i++) {
        await _firestore
            .collection('cities')
            .doc(cityName.toLowerCase())
            .collection('challenges')
            .doc('challenge_$i')
            .set({
          'name': challenges[i]['name'],
          'category': challenges[i]['category'],
          'gps_verifiable': challenges[i]['gps_verifiable'] ?? false, // Default to false if not provided
          'location': challenges[i]['location'], // Can be null if not GPS verifiable
        });
      }
      print("Challenges added for $cityName.");
    } catch (e) {
      print("Error adding challenges for $cityName: $e");
    }
  }
}