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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDWZjXWUzDHY9JE-GxN70kbX0wCgdzcCRc',
    appId: '1:922078877814:android:a7f58e21c05cdfb6f7e757',
    messagingSenderId: '922078877814',
    projectId: 'fucking-please',
    databaseURL: 'https://fucking-please-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'fucking-please.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCEHnIRJXkZsYqBdK7K3DWn3U4lMCmXmtQ',
    appId: '1:922078877814:ios:f6dce83404dbcb06f7e757',
    messagingSenderId: '922078877814',
    projectId: 'fucking-please',
    databaseURL: 'https://fucking-please-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'fucking-please.appspot.com',
    iosClientId: '922078877814-59o9jstho6b357v43gdujqe6kcujsebv.apps.googleusercontent.com',
    iosBundleId: 'com.example.internalAssessment',
  );
}
