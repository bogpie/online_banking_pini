// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAJvntlBXgh_BMqJp1Rmd4EzZ00kUGWlNs',
    appId: '1:722734900618:web:c500e37c5ab4fea11c1473',
    messagingSenderId: '722734900618',
    projectId: 'onlinebankingpini',
    authDomain: 'onlinebankingpini.firebaseapp.com',
    databaseURL: 'https://onlinebankingpini-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'onlinebankingpini.appspot.com',
    measurementId: 'G-VVXF8L21ZQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCy7g62pmCxgqkHLLVVDYUnOX_j56Fmn_A',
    appId: '1:722734900618:android:63d218f602da51971c1473',
    messagingSenderId: '722734900618',
    projectId: 'onlinebankingpini',
    databaseURL: 'https://onlinebankingpini-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'onlinebankingpini.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDHGBjvNWJdiVqV3aOwIuNSs2qenRuTHmc',
    appId: '1:722734900618:ios:d9395213bbb6a7111c1473',
    messagingSenderId: '722734900618',
    projectId: 'onlinebankingpini',
    databaseURL: 'https://onlinebankingpini-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'onlinebankingpini.appspot.com',
    iosClientId: '722734900618-sqchhj23qkcmj8ghn613cumtpp67mge7.apps.googleusercontent.com',
    iosBundleId: 'com.pini.onlineBankingPini',
  );
}
