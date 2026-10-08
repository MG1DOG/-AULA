import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
          'DefaultFirebaseOptions have not been configured for Linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: "AIzaSyDqWcAiibGJJzKUYpJMvkAYjfoBHgFRwiI",
    authDomain: "pdm-mg.firebaseapp.com",
    projectId: "pdm-mg",
    storageBucket: "pdm-mg.firebasestorage.app",
    messagingSenderId: "122409739161",
    appId: "1:122409739161:web:7830670c8393ac53b2a908",
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyDqWcAiibGJJzKUYpJMvkAYjfoBHgFRwiI",
    authDomain: "pdm-mg.firebaseapp.com",
    projectId: "pdm-mg",
    storageBucket: "pdm-mg.firebasestorage.app",
    messagingSenderId: "122409739161",
    appId: "1:122409739161:web:7830670c8393ac53b2a908",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyDqWcAiibGJJzKUYpJMvkAYjfoBHgFRwiI",
    authDomain: "pdm-mg.firebaseapp.com",
    projectId: "pdm-mg",
    storageBucket: "pdm-mg.firebasestorage.app",
    messagingSenderId: "122409739161",
    appId: "1:122409739161:web:7830670c8393ac53b2a908",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyDqWcAiibGJJzKUYpJMvkAYjfoBHgFRwiI",
    authDomain: "pdm-mg.firebaseapp.com",
    projectId: "pdm-mg",
    storageBucket: "pdm-mg.firebasestorage.app",
    messagingSenderId: "122409739161",
    appId: "1:122409739161:web:7830670c8393ac53b2a908",
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: "AIzaSyDqWcAiibGJJzKUYpJMvkAYjfoBHgFRwiI",
    authDomain: "pdm-mg.firebaseapp.com",
    projectId: "pdm-mg",
    storageBucket: "pdm-mg.firebasestorage.app",
    messagingSenderId: "122409739161",
    appId: "1:122409739161:web:7830670c8393ac53b2a908",
  );
}
