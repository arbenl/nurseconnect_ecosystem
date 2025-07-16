// lib/core/router/app_router.dart
import 'package:flutter/material.dart'; // Needed for Page transitions/builders potentially
import 'package:go_router/go_router.dart';

// Import your screen widgets
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/nurse_registration_screen.dart';
// *** IMPORT NURSE HOME SCREEN ***
import '../../features/home/presentation/screens/nurse_home_screen.dart'; // Nurse Home Screen
import '../../features/active_service/presentation/screens/active_service_screen.dart'; // Active Service Screen
import '../../features/history/presentation/screens/service_history_screen.dart'; // Service History Screen
import '../../features/profile/presentation/screens/nurse_profile_screen.dart'; // Nurse Profile Screen

// Use an enum or class for route names for type safety and autocompletion
class AppRoutes {
  static const String login = '/login';
  static const String registration = '/registration';
   // *** ADD NURSE HOME ROUTE NAME ***
  static const String nurseHome = '/nurse-home';
  static const String activeService = '/active-service/:serviceRequestId';
  static const String serviceHistory = '/service-history';
  static const String nurseProfile = '/nurse-profile';
}

// Configure the GoRouter instance
final GoRouter router = GoRouter(
  initialLocation: AppRoutes.login, // Start at the login screen
  debugLogDiagnostics: true, // Log navigation information in debug mode

  // Define the routes for the application
  routes: <RouteBase>[
    // Login Route
    GoRoute(
      path: AppRoutes.login, // The URL path
      name: AppRoutes.login, // Optional but helpful name
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen(); // Widget to build for this route
      },
    ),

    // Nurse Registration Route
    GoRoute(
      path: '/register-nurse',
      name: 'registerNurse',
      builder: (BuildContext context, GoRouterState state) {
        return const NurseRegistrationScreen();
      },
    ),

       // --- *** ADD NURSE HOME ROUTE *** ---
    GoRoute(
      name: AppRoutes.nurseHome,
      path: AppRoutes.nurseHome,
      builder: (context, state) => const NurseHomeScreen(),
    ),
    GoRoute(
      name: AppRoutes.activeService,
      path: AppRoutes.activeService,
      builder: (context, state) => ActiveServiceScreen(
        serviceRequestId: state.pathParameters['serviceRequestId']!,
      ),
    ),
    GoRoute(
      name: AppRoutes.serviceHistory,
      path: AppRoutes.serviceHistory,
      builder: (context, state) => const ServiceHistoryScreen(),
    ),
    GoRoute(
      name: AppRoutes.nurseProfile,
      path: AppRoutes.nurseProfile,
      builder: (context, state) => const NurseProfileScreen(),
    ),
    // --- *** END NURSE HOME ROUTE *** ---

    // TODO: Add other routes here (e.g., profile, service details)
  ],

  // Optional: Error handling for routes not found
  // errorBuilder: (context, state) => ErrorScreen(error: state.error),
);