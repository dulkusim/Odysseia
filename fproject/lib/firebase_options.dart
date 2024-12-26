// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBjPU24rMzF0CljRUxq-t72ppi0ZojS22Y',
    appId: '1:1080173658538:web:ae4c60f70d9a5d4dbb6bd3',
    messagingSenderId: '1080173658538',
    projectId: 'odysseiaapp',
    authDomain: 'odysseiaapp.firebaseapp.com',
    storageBucket: 'odysseiaapp.firebasestorage.app',
    measurementId: 'G-V17PLB4G1J',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCp_Y1rsCie8vYoiWq9rJTidjkEuxpFRj0',
    appId: '1:1080173658538:android:d94e9485e42c6059bb6bd3',
    messagingSenderId: '1080173658538',
    projectId: 'odysseiaapp',
    storageBucket: 'odysseiaapp.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAoXwVJFMhcurzd6NXseIQxVZXuMIiMkPU',
    appId: '1:1080173658538:ios:ee7288cad5e0465ebb6bd3',
    messagingSenderId: '1080173658538',
    projectId: 'odysseiaapp',
    storageBucket: 'odysseiaapp.firebasestorage.app',
    iosBundleId: 'com.example.fproject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAoXwVJFMhcurzd6NXseIQxVZXuMIiMkPU',
    appId: '1:1080173658538:ios:ee7288cad5e0465ebb6bd3',
    messagingSenderId: '1080173658538',
    projectId: 'odysseiaapp',
    storageBucket: 'odysseiaapp.firebasestorage.app',
    iosBundleId: 'com.example.fproject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBjPU24rMzF0CljRUxq-t72ppi0ZojS22Y',
    appId: '1:1080173658538:web:aac262e142e61f35bb6bd3',
    messagingSenderId: '1080173658538',
    projectId: 'odysseiaapp',
    authDomain: 'odysseiaapp.firebaseapp.com',
    storageBucket: 'odysseiaapp.firebasestorage.app',
    measurementId: 'G-001Z9VZGL3',
  );
}
