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
    apiKey: 'AIzaSyD2YlvC1EikJK8Hc1TtjiJ6HXGaXOdkohs',
    appId: '1:1026224643518:web:9699a585b438950af72def',
    messagingSenderId: '1026224643518',
    projectId: 'heyplan-5e739',
    authDomain: 'heyplan-5e739.firebaseapp.com',
    storageBucket: 'heyplan-5e739.appspot.com',
    measurementId: 'G-XMKBK257YZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBIVHIHuTx1fQf6tHXdbltF0PkQBo34OcU',
    appId: '1:1026224643518:android:2c392df948ace8e1f72def',
    messagingSenderId: '1026224643518',
    projectId: 'heyplan-5e739',
    storageBucket: 'heyplan-5e739.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDgZyNio4g9cZJh_HlCpH62zFTkYqhYV3M',
    appId: '1:1026224643518:ios:0b9700ad5a87dd22f72def',
    messagingSenderId: '1026224643518',
    projectId: 'heyplan-5e739',
    storageBucket: 'heyplan-5e739.appspot.com',
    iosClientId: '1026224643518-pv7i7uirl53a6fu8ke16lbejifqdh9to.apps.googleusercontent.com',
    iosBundleId: 'og.heyplan.app',
  );
}
