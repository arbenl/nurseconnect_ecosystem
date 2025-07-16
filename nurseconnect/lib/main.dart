// nurseconnect/lib/main.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:async';

import 'firebase_options.dart';
import 'core/dependency_injection/injection_container.dart';
import 'core/router/app_router.dart';
import 'package:nurseconnect/core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Configure Firebase Emulators for debug mode
  if (kDebugMode) {
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8081);
    FirebaseAuth.instance.useAuthEmulator('localhost', 9098);
    FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  }

  // ── Activate Firebase App Check ──
  // For local/dev: use the Debug provider. In production switch to Play Integrity.
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
    // webRecaptchaSiteKey: 'YOUR_WEB_RECAPTCHA_SITE_KEY', // if you ever build for web
  );

  // Wire up GetIt
  await init();

  // Initialize Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(MaterialApp.router(
    title: 'NurseConnect',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    routerConfig: router,
  ));
}