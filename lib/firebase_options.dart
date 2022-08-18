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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA6jhhuT5vOQn-qP3Er3TL0o0IbqyTCBog',
    appId: '1:1033957654266:web:efa5d29c5143859be39343',
    messagingSenderId: '1033957654266',
    projectId: 'whatsapp-backend-ac6b0',
    authDomain: 'whatsapp-backend-ac6b0.firebaseapp.com',
    storageBucket: 'whatsapp-backend-ac6b0.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAf6ujpnouGXKiun0tR12mYpFtrbbsX4xc',
    appId: '1:1033957654266:android:4df45ab08d4493c2e39343',
    messagingSenderId: '1033957654266',
    projectId: 'whatsapp-backend-ac6b0',
    storageBucket: 'whatsapp-backend-ac6b0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAVPp8nr4AhuRJTLzu_Uyw1pxKgQShK5o0',
    appId: '1:1033957654266:ios:6c13a5840058d1a8e39343',
    messagingSenderId: '1033957654266',
    projectId: 'whatsapp-backend-ac6b0',
    storageBucket: 'whatsapp-backend-ac6b0.appspot.com',
    iosClientId: '1033957654266-1q8mfll2oj55lgr9m2lpocscd0uta9us.apps.googleusercontent.com',
    iosBundleId: 'com.example.wenubey.whatsappCloneFlutter',
  );
}
