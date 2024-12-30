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
/*void main() async {
  // List of image URLs for the challenges
List<String> budapestImages = [
    'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bb/Royal_Castle_in_Warsaw%2C_Poland%2C_2022%2C_03.jpg/1024px-Royal_Castle_in_Warsaw%2C_Poland%2C_2022%2C_03.jpg', //0
    'https://upload.wikimedia.org/wikipedia/commons/thumb/3/35/Warsaw_Old_Town_Market_Square_10.JPG/1280px-Warsaw_Old_Town_Market_Square_10.JPG', //1
    'https://images.unsplash.com/photo-1573362924900-6395ff462288?q=80&w=2073&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', //2
    'https://upload.wikimedia.org/wikipedia/commons/thumb/2/26/Museum_of_the_History_of_Polish_Jews_in_Warsaw_building_0011.jpg/1280px-Museum_of_the_History_of_Polish_Jews_in_Warsaw_building_0011.jpg', //3
    'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Pierogi_z_mas%C5%82em_-_2023.03.31.jpg/800px-Pierogi_z_mas%C5%82em_-_2023.03.31.jpg', //4
    'https://images.unsplash.com/photo-1565351605775-a9df88c818a1?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', //5
    'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4d/Warszawa-Ogr%C3%B3d_Saski_fontanna.jpg/1280px-Warszawa-Ogr%C3%B3d_Saski_fontanna.jpg', //6
    'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cd/Muzeum_Powstania_Warszawskiego_2023.jpg/1024px-Muzeum_Powstania_Warszawskiego_2023.jpg', //7
    'https://images.unsplash.com/photo-1620999128404-6028e48ba01f?q=80&w=2069&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', //8
    'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.polonist.com%2Fpolish-zurek-soup%2F&psig=AOvVaw3AuiMlDUUer16tsNI5udAM&ust=1735685267721000&source=images&cd=vfe&opi=89978449&ved=0CBAQjRxqFwoTCND9n9HJ0IoDFQAAAAAdAAAAABAE', //9
    'https://images.unsplash.com/photo-1464520606738-6dab99180409?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', //10
    'https://upload.wikimedia.org/wikipedia/commons/2/21/Widok_na_krakowskie_przedmiescie_po_remoncie.jpg', //11
    'https://lh3.googleusercontent.com/p/AF1QipOlpYglgDF6NaewuW-PlZhtHljWVSaynDJijd8D=s1360-w1360-h1020', //12
    'https://upload.wikimedia.org/wikipedia/commons/thumb/7/71/Zentrumkop1_DSC1330.JPG/1280px-Zentrumkop1_DSC1330.JPG', //13
    'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f2/Bigos_%281%29.jpg/1024px-Bigos_%281%29.jpg', //14
    'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7b/Barbakan_w_Warszawie_-_03.jpg/1280px-Barbakan_w_Warszawie_-_03.jpg', //15
    'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/Zamek_Ostrogskich_w_Warszawie_2022.jpg/1024px-Zamek_Ostrogskich_w_Warszawie_2022.jpg', //16
    'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/Czerwienski_boulevard%2C_Krakow%2C_Poland.jpg/1920px-Czerwienski_boulevard%2C_Krakow%2C_Poland.jpg', //17
    'https://upload.wikimedia.org/wikipedia/commons/thumb/7/73/Filharmonia_Narodowa_w_Warszawie_2020.jpg/800px-Filharmonia_Narodowa_w_Warszawie_2020.jpg', //18
    'https://images.unsplash.com/photo-1613255347968-aa2aaa353976?q=80&w=1926&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', //19
    ];


  // Call the function to add images to challenges for Athens
 // await addImagesToChallenges("athens", athensImages);
//}
*/