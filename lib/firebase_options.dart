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
    apiKey: 'AIzaSyDEfc5nCULgW5ixArxmkvVAN5dN6nTzn5U',
    appId: '1:395012212058:web:efe6b65f23d99d7f299f63',
    messagingSenderId: '395012212058',
    projectId: 'eflashcard-4dfea',
    authDomain: 'eflashcard-4dfea.firebaseapp.com',
    storageBucket: 'eflashcard-4dfea.appspot.com',
    measurementId: 'G-FZQTV5P6ER',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCl66TshF7A_t6zFcJmlMD0yfMCnCZfg44',
    appId: '1:395012212058:android:0d402fdccd447c16299f63',
    messagingSenderId: '395012212058',
    projectId: 'eflashcard-4dfea',
    storageBucket: 'eflashcard-4dfea.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBeOzVk2jas1BeKhNCXI52Nzlz9hzL7HFw',
    appId: '1:395012212058:ios:a8852481f9dcf389299f63',
    messagingSenderId: '395012212058',
    projectId: 'eflashcard-4dfea',
    storageBucket: 'eflashcard-4dfea.appspot.com',
    iosClientId: '395012212058-bi0ipeaml6o5l5dcueoi9rske9s7srgv.apps.googleusercontent.com',
    iosBundleId: 'com.example.eflashcard',
  );
}