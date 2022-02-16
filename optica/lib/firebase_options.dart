// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDmF_TqpCClFSl8ijamHry_fSXmipe50Lc',
    appId: '1:835584545819:web:d6d0e1e72cdb54f025d4be',
    messagingSenderId: '835584545819',
    projectId: 'optica-tfg',
    authDomain: 'optica-tfg.firebaseapp.com',
    databaseURL:
        'https://optica-tfg-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'optica-tfg.appspot.com',
    measurementId: 'G-DDTNM5QJ1M',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDuhFbidkE-m1Dj_92teGj3jV27XYuLiIw',
    appId: '1:835584545819:android:4ff1a34c371eb99b25d4be',
    messagingSenderId: '835584545819',
    projectId: 'optica-tfg',
    databaseURL:
        'https://optica-tfg-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'optica-tfg.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAIPhbNHaUsp3p8Xvwity_cjLJ-gM28Cbk',
    appId: '1:835584545819:ios:cd4c03d0464003d425d4be',
    messagingSenderId: '835584545819',
    projectId: 'optica-tfg',
    databaseURL:
        'https://optica-tfg-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'optica-tfg.appspot.com',
    iosClientId:
        '835584545819-507m91c67hmf19tnmn3qfo61cgk486ci.apps.googleusercontent.com',
    iosBundleId: 'comdd',
  );
}
