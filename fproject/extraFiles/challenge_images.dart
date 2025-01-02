/*import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addImagesToChallenges(String cityName, List<String> imageUrls) async {
  try {
    // Reference the challenges collection for the specific city
    CollectionReference challengesCollection = FirebaseFirestore.instance
        .collection('cities')
        .doc(cityName.toLowerCase()) // Assuming city names are stored in lowercase
        .collection('challenges');

    // Fetch all challenge documents
    QuerySnapshot snapshot = await challengesCollection.get();

    if (snapshot.docs.length != imageUrls.length) {
      print("Number of images provided doesn't match the number of challenges!");
      return;
    }

    // Loop through each document and add the image attribute
    for (int i = 0; i < snapshot.docs.length; i++) {
      String challengeId = snapshot.docs[i].id;
      String imageUrl = imageUrls[i];

      // Update the document with the image URL
      await challengesCollection.doc(challengeId).update({
        'image': imageUrl,
      });
      print("Added image for challenge $challengeId: $imageUrl");
    }

    print("Images added successfully for all challenges in $cityName.");
  } catch (e) {
    print("Error adding images to challenges: $e");
  }
}
*/
/*
void main() async {
// List of image URLs for the challenges
List<String> budapestImages = [
    'https://images.unsplash.com/photo-1555368062-a9b335f1e997?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTd8fGFjcm9wb2xpc3xlbnwwfHwwfHx8Mg%3D%3D', //0
    'https://images.unsplash.com/photo-1676831410404-ee79a62c8188?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8cGFydGhlbm9ufGVufDB8fDB8fHwy', //1
    '', //10
    '', //11
    'https://images.unsplash.com/photo-1647665027158-4b29113244c3?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cGxha2F8ZW58MHx8MHx8fDI%3D', //12
    '', //13
    '', //14
    'https://images.pexels.com/photos/18604086/pexels-photo-18604086/free-photo-of-byzantine-and-christian-museum-in-athens.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2', //15
    '', //16
    '', //17
    '', //18
    '', //19
    'https://images.unsplash.com/photo-1647665027158-4b29113244c3?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cGxha2F8ZW58MHx8MHx8fDI%3D', //2
    '', //3
    'https://images.unsplash.com/photo-1734974121561-11aee7d3cebd?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGl0YSUyMGd5cm9zfGVufDB8fDB8fHwy', //4
    'https://images.unsplash.com/photo-1595410604352-56442920c89e?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8bHljYWJldHR1c3xlbnwwfHwwfHx8Mg%3D%3D', //5
    'https://images.unsplash.com/photo-1722602199455-1a39542be0a4?q=80&w=2047&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', //6
    'https://images.unsplash.com/photo-1514864120528-927cf03d73d9?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fHN5bnRhZ21hfGVufDB8fDB8fHwy', //7
    '', //8
    '', //9
];

// Call the function to add images to challenges for Athens
await addImagesToChallenges("athens", athensImages);
}


List<String> cityImages = [
    '', //0
    '', //1
    '', //10
    '', //11
    '', //12
    '', //13
    '', //14
    '', //15
    '', //16
    '', //17
    '', //18
    '', //19
    '', //2
    '', //3
    '', //4
    '', //5
    '', //6
    '', //7
    '', //8
    '', //9
];
*/