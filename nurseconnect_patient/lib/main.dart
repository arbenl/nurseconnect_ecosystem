// nurseconnect_patient/lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:async';

import 'firebase_options.dart';
import 'core/dependency_injection/injection_container.dart';
import 'core/router/app_router.dart';
import 'core/utils/logger.dart';

import 'package:nurseconnect_patient/core/utils/seeding_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (kDebugMode) {
    try {
      AppLogger.log("Debug mode detected. Attempting to connect to Firebase Emulators...", tag: "main");
      // Use 10.0.2.2 for Android emulators to connect to localhost
      final host = defaultTargetPlatform == TargetPlatform.android ? '10.0.2.2' : 'localhost';
      
      FirebaseFirestore.instance.useFirestoreEmulator(host, 8081);
      await FirebaseAuth.instance.useAuthEmulator(host, 9098);
      FirebaseFunctions.instance.useFunctionsEmulator(host, 5001);
      
      await SeedingService().seedUsers();

      // Use the debug provider for App Check on emulators
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug,
        appleProvider: AppleProvider.debug,
      );
      
      AppLogger.log("Successfully connected to Firebase Emulators.", tag: "main");
    } catch (e) {
      AppLogger.error("Error connecting to Firebase Emulators. The app will use the live Firebase services.", tag: "main", error: e);
    }
  } else {
    AppLogger.log("Release mode detected. Connecting to live Firebase services.", tag: "main");
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity, // Use Play Integrity for production
      appleProvider: AppleProvider.appAttest,
    );
  }

  // Initialize Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Initialize FCM and request permissions.
  // The token will be saved upon login.
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // It's good practice to handle token refreshes. A proper implementation
  // would require a way to get the currently logged-in user's ID and
  // update the token on your server. This can be handled by a service that
  // listens to auth state changes. For now, we just log it.
  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
    AppLogger.log("FCM Token refreshed: $fcmToken", tag: "main:onTokenRefresh");
    // TODO: Implement a service to update the token for the logged-in user.
  });

  await init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        return MaterialApp.router(
          title: 'PatientConnect',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          routerConfig: router,
        );
      },
    );
  }
}