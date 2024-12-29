import 'package:cloud_firestore/cloud_firestore.dart';

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

void main() async {
  final PopulateChallengesManual populateChallengesManual = PopulateChallengesManual();

  // Challenges for Athens
  List<Map<String, dynamic>> athensChallenges = [
    {
      'name': 'Visit the Acropolis',
      'category': 'Sights',
      'gps_verifiable': true,
      'location': GeoPoint(37.9715, 23.7257), // Latitude, Longitude for Acropolis
    },
    {
      'name': 'Explore the Parthenon',
      'category': 'Sights',
      'gps_verifiable': true,
      'location': GeoPoint(37.9715, 23.7267),
    },
    {
      'name': 'Walk through Plaka',
      'category': 'Sights',
      'gps_verifiable': false,
      'location': null,
    },
    {
      'name': 'Visit the National Archaeological Museum',
      'category': 'Museums',
      'gps_verifiable': true,
      'location': GeoPoint(37.9903, 23.7314),
    },
    {
      'name': 'Try traditional Souvlaki',
      'category': 'Food',
      'gps_verifiable': false,
      'location': null,
    },
    // Add more challenges as needed
  ];

  // Add challenges for Athens
  await populateChallengesManual.addChallengesForCity("Athens", athensChallenges);

  // Example for Rome (You can create similar lists for other cities)
  List<Map<String, dynamic>> romeChallenges = [
    {
      'name': 'Visit the Colosseum',
      'category': 'Sights',
      'gps_verifiable': true,
      'location': GeoPoint(41.8902, 12.4922),
    },
    {
      'name': 'Toss a coin into Trevi Fountain',
      'category': 'Sights',
      'gps_verifiable': true,
      'location': GeoPoint(41.9009, 12.4833),
    },
    {
      'name': 'Explore the Roman Forum',
      'category': 'Sights',
      'gps_verifiable': true,
      'location': GeoPoint(41.8925, 12.4853),
    },
    {
      'name': 'Try Italian Gelato',
      'category': 'Food',
      'gps_verifiable': false,
      'location': null,
    },
    // Add more challenges as needed
  ];

  // Add challenges for Rome
  await populateChallengesManual.addChallengesForCity("Rome", romeChallenges);
}
