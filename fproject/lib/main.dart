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

  runApp(const OdysseiaApp());
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  bool _isPasswordHidden = true; // Boolean to toggle password visibility

  Future<void> _signUp() async {
  try {
    // Create user with email and password
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    // Create a new user document in Firestore
    final user = userCredential.user;
    if (user != null) {
      await _createUserDocument(user.uid);
    }

    // Navigate to Sign-In Screen
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
    }
  } on FirebaseAuthException catch (e) {
    if (mounted) {
      setState(() {
        if (e.code == 'weak-password') {
          _errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          _errorMessage = 'An account already exists for this email.';
        } else {
          _errorMessage = 'Failed to create account. Please try again.';
        }
      });
    }
  } catch (e) {
    if (mounted) {
      setState(() {
        _errorMessage = 'An unexpected error occurred.';
      });
    }
  }
}


  Future<void> _createUserDocument(String uid) async {
  try {
    // Extract the username from the email
    final email = _emailController.text.trim();
    final username = email.split('@')[0]; // Get the prefix before '@'

    // Initial user data
    final initialUserData = {
      'email': email,
      'language': 'English', // Default language
      'profilepicture': '', // Default empty profile picture
      'preferences': [], // Default empty preferences
      'gallery': [], // Default empty gallery
      'friends': [], // Default empty friends list
      'awards': [], // Default empty awards list
      'username': username, // Set default username
      'visitedcities': [],
      'challenges': 10
    };

    // Save user data in Firestore
    await _firestore.collection('Users').doc(uid).set(initialUserData);
    print('User document created successfully');
  } catch (e) {
    print('Error creating user document: $e');
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

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  bool _isPasswordHidden = true; // Boolean to toggle password visibility

  Future<void> _signIn() async {
  try {
    // Authenticate user
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    // Fetch user data from Firestore
    final user = userCredential.user;
    if (user != null) {
      final userData = await _fetchUserData(user.uid);

      if (userData.isNotEmpty && mounted) {
        // Navigate to MainScreen and pass user data
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(userData: userData),
          ),
        );
      } else if (mounted) {
        setState(() {
          _errorMessage = 'Failed to fetch user data. Please try again.';
        });
      }
    }
  } on FirebaseAuthException catch (e) {
    if (mounted) {
      setState(() {
        if (e.code == 'user-not-found') {
          _errorMessage = 'No user found for this email.';
        } else if (e.code == 'wrong-password') {
          _errorMessage = 'Incorrect password.';
        } else {
          _errorMessage = 'Failed to sign in. Please try again.';
        }
      });
    }
  } catch (e) {
    if (mounted) {
      setState(() {
        _errorMessage = 'An unexpected error occurred.';
      });
    }
  }
}


  Future<Map<String, dynamic>> _fetchUserData(String uid) async {
    try {
      final snapshot = await _firestore.collection('Users').doc(uid).get();

      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception('User data not found.');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return {};
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
              decoration: const InputDecoration(
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
                border: const OutlineInputBorder(),
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
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
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
 
class OdysseiaApp extends StatelessWidget {
  const OdysseiaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(), // Start with an AuthWrapper to manage login state
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Listen to auth state changes
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Loading state
        }

        if (snapshot.hasData) {
          // User is logged in, fetch user data
          return FutureBuilder<Map<String, dynamic>>(
            future: fetchUserData(snapshot.data!.uid),
            builder: (context, userDataSnapshot) {
              if (userDataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (userDataSnapshot.hasError || !userDataSnapshot.hasData) {
                return Center(child: Text("Error loading user data"));
              } else {
                final userData = userDataSnapshot.data!;
                return MainScreen(userData: userData); // Pass user data to MainScreen
              }
            },
          );
        } else {
          return SignInScreen(); // User not logged in, show SignInScreen
        }
      },
    );
  }

  Future<Map<String, dynamic>> fetchUserData(String uid) async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception('User data not found');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return {};
    }
  }
}

class MainScreen extends StatefulWidget {
  final Map<String, dynamic> userData; // Pass user data to MainScreen

  const MainScreen({required this.userData, Key? key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  ValueNotifier<int> _selectedIndexNotifier = ValueNotifier<int>(0); // Use ValueNotifier

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      HomeScreen(userData: widget.userData),
      _buildChallengesScreen(),
      MapScreen(),
      ProfileScreen(),
    ];
  }

  Widget _buildChallengesScreen() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text("No city selected"));
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final currentCity = userData['current_city'] ?? '';

        if (currentCity.isEmpty) {
          return Center(child: Text("No city selected"));
        }

        return ChallengesScreen(cityName: currentCity);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _selectedIndexNotifier,
      builder: (context, selectedIndex, child) {
        return Scaffold(
          body: _screens[selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (index) => _selectedIndexNotifier.value = index,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 30),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(HugeIcons.strokeRoundedSword03, size: 30),
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
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
          ),
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> userData; // Add userData as a parameter

  const HomeScreen({required this.userData, Key? key}) : super(key: key);

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
      final snapshot = await FirebaseFirestore.instance.collection('cities').get();
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
      .where((item) => item.toLowerCase().startsWith(_searchQuery.toLowerCase()))
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
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Odysseia',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0,
                                  ),
                                ),
                                ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.search, size: 30),
                              onPressed: () {
                                setState(() {
                                  _isSearching = true;
                                });
                              },
                            ),
                          ],
                        ),
                ),
                const Divider(
                  color: Colors.black,
                  thickness: 2,
                  height: 10,
                ),
                // "Based on your preferences" and its content
                _isLoadingCities
                    ? const Center(child: CircularProgressIndicator())
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
                        final selectedCityName = _searchSuggestions[originalIndex];

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
  String userId = ""; // Add a variable to store the userId

  @override
  void initState() {
    super.initState();
    _initializeUserId(); // Initialize userId and fetch preferences
  }

  Future<void> _initializeUserId() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      userId = currentUser.uid; // Set the userId from the currently logged-in user
      await _fetchUserPreferences(); // Fetch preferences for the logged-in user
    }
  }

  Future<void> _fetchUserPreferences() async {
    try {
      // Fetch user preferences from Firestore
      final userSnapshot = await FirebaseFirestore.instance.collection('Users').doc(userId).get();
      if (userSnapshot.exists) {
        final userData = userSnapshot.data();
        final preferences = List<String>.from(userData?['preferences'] ?? []);
        
        setState(() {
          _selectedPreferences = preferences;
        });

        // Filter cities based on preferences
        await _filterCitiesByPreferences(preferences);
      }
    } catch (e) {
      print("Error fetching user preferences: $e");
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
          userId: userId, // Pass the userId here
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
        SizedBox(height: 20),
        WeekendTripsSection(),
      ],
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  final String userId; // Add userId parameter
  final List<String> selectedFilters;
  final Function(List<String>) onFiltersApplied;

  const FilterBottomSheet({
    required this.userId,
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

  Future<void> _savePreferences(List<String> preferences) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .update({'preferences': preferences});
    } catch (e) {
      print("Error saving preferences: $e");
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

              // Save preferences to Firestore
              _savePreferences(selectedFilters);

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
        SizedBox(height: 20),

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
        SizedBox(height: 20),

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
        SizedBox(height: 10),
      ],
    );
  }
}

class CityPageInfo extends StatelessWidget {
  final String cityName;

  const CityPageInfo({required this.cityName, Key? key}) : super(key: key);

Future<void> _beginTrip(BuildContext context) async {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final userDoc = FirebaseFirestore.instance.collection('Users').doc(userId);

  final userSnapshot = await userDoc.get();
  final currentCity = userSnapshot.data()?['current_city'] ?? "";

  if (currentCity.isNotEmpty) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Active Trip"),
        content: Text("You must end your current trip before starting a new one."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
    return;
  }

  await userDoc.update({'current_city': cityName});

  Navigator.pop(context); // Close the CityPageInfo screen

  // Notify MainScreenState to switch to Challenges tab
  final mainScreenState = context.findAncestorStateOfType<MainScreenState>();
  mainScreenState?._selectedIndexNotifier.value = 1; // Switch to Challenges tab
}

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
              onPressed: () => _beginTrip(context), // Use the _beginTrip function here
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
                  DisplayChallengeCards(cityName: cityName),
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
            style: TextStyle(fontSize: 18, color: Colors.black),
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
  final String cityName;

  const DisplayChallengeCards({required this.cityName, Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> fetchChallenges(String cityName) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('cities')
          .doc(cityName.toLowerCase())
          .collection('challenges')
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching challenges for $cityName: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchChallenges(cityName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No challenges available."));
        } else {
          final challenges = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: challenges.length,
            itemBuilder: (context, index) {
              final challenge = challenges[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.0),
                child: ChallengeCard(
                  title: challenge['name'],
                  category: challenge['category'],
                  imageUrl: challenge['image'], // Display the challenge image
                ),
              );
            },
          );
        }
      },
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
                  MaterialPageRoute(builder: (_) => CitiesScreen()),
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