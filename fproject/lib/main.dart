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
  int _selectedIndex = 0; // To track the selected navigation item

  // A list of widgets to display for each tab
  final List<Widget> _screens = [
    HomeScreen(), // Updated Home screen
    ChallengesScreen(cityName: "Athens, Greece"), // Challenges screen
    MapScreen(),// Map screen
    ProfileScreen(), // Profile screen
  ];

    @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          ),
          BottomNavigationBarItem(
            icon: Icon(HugeIcons.strokeRoundedSword03, size: 30), // Placeholder for battles icon
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
        ],
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
                        // Handle suggestion selection
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CityPageInfo(
                              cityName: _filteredSuggestions[index+1],
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
                  // Show the filter modal
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return FilterBottomSheet();
                    },
                    backgroundColor: Colors.transparent,
                  );
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
                CityCard(cityName: "London"),
                CityCard(cityName: "Lisbon"),
                CityCard(cityName: "New York"), // Fourth city added
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

class FilterBottomSheet extends StatefulWidget {
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
              Navigator.pop(context); // Close the modal
              print('Selected Filters: ${_filters.entries.where((e) => e.value).map((e) => e.key).toList()}');
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
                CityCard(cityName: "Mykonos"),
                CityCard(cityName: "Santorini"),
                CityCard(cityName: "Rethymno"),
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
