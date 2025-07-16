import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import your screen widgets
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/registration_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/history/presentation/screens/patient_service_history_screen.dart';
import '../../features/landing/landing_screen.dart';
 
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/privacy_settings_screen.dart';
import '../../features/profile/presentation/screens/activity_log_screen.dart';
import '../../features/select_service/presentation/screens/select_service_screen.dart';
import '../../features/select_service/presentation/screens/service_confirmation_screen.dart';
import '../../features/payment/presentation/screens/payment_methods_screen.dart';
import '../../features/payment/presentation/screens/add_payment_method_screen.dart';
import '../../features/payment/presentation/screens/select_payment_method_screen.dart';

import '../dependency_injection/injection_container.dart'; // Adjust path if your service locator 'sl' is defined elsewhere.

import 'package:nurseconnect_patient/features/profile/presentation/bloc/profile_bloc.dart';

import 'package:nurseconnect_patient/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:nurseconnect_patient/features/history/presentation/bloc/bloc.dart';

// Use an enum or class for route names for type safety and autocompletion
class AppRoutes {
  static const String landing = '/';
  static const String login = '/login';
  static const String registration = '/registration';
  static const String home = '/home'; // Changed from '/' to '/home' for clarity
  static const String trackService = '/track-service'; // New route for tracking
  // *** ADD NURSE HOME ROUTE NAME ***
  static const String nurseHome = '/nurse-home';
  static const String patientServiceHistory = '/patient-service-history';
  static const String patientProfile = '/patient-profile';
  static const String selectService = '/select-service';
  static const String serviceConfirmation = '/service-confirmation';
  static const String paymentMethods = '/payment-methods';
  static const String addPaymentMethod = '/add-payment-method';
  static const String selectPaymentMethod = '/select-payment-method';
  static const String privacySettings = '/profile/privacy';
  static const String activityLog = '/profile/activity-log';
}

// Configure the GoRouter instance
final GoRouter router = GoRouter(
  initialLocation: AppRoutes.landing,
  debugLogDiagnostics: true,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.landing,
      name: AppRoutes.landing,
      builder: (BuildContext context, GoRouterState state) {
        return const LandingScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.login,
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),

    GoRoute(
      path: '/register-patient',
      name: 'registerPatient',
      builder: (BuildContext context, GoRouterState state) {
        return const RegistrationScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.registration,
      name: AppRoutes.registration,
      builder: (BuildContext context, GoRouterState state) {
        return const RegistrationScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.home,
      name: AppRoutes.home,
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.selectService,
      name: AppRoutes.selectService,
      builder: (BuildContext context, GoRouterState state) {
        return const SelectServiceScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.serviceConfirmation,
      name: AppRoutes.serviceConfirmation,
      builder: (BuildContext context, GoRouterState state) {
        final NursingService service = state.extra as NursingService;
        return ServiceConfirmationScreen(selectedService: service);
      },
    ),
    GoRoute(
      path: AppRoutes.paymentMethods,
      name: AppRoutes.paymentMethods,
      builder: (BuildContext context, GoRouterState state) {
        return BlocProvider(
          create: (_) => sl<PaymentBloc>()..add(LoadPaymentMethods(userId: FirebaseAuth.instance.currentUser!.uid)),
          child: const PaymentMethodsScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.addPaymentMethod,
      name: AppRoutes.addPaymentMethod,
      builder: (BuildContext context, GoRouterState state) {
        return const AddPaymentMethodScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.selectPaymentMethod,
      name: AppRoutes.selectPaymentMethod,
      builder: (BuildContext context, GoRouterState state) {
        return const SelectPaymentMethodScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.patientServiceHistory,
      name: AppRoutes.patientServiceHistory,
      builder: (BuildContext context, GoRouterState state) {
        return BlocProvider(
          create: (_) => sl<HistoryBloc>()..add(LoadHistory(FirebaseAuth.instance.currentUser!.uid)),
          child: const PatientServiceHistoryScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.patientProfile,
      name: AppRoutes.patientProfile,
      builder: (BuildContext context, GoRouterState state) {
        return const ProfileScreen();
      },
      routes: [
        GoRoute(
          path: 'edit',
          name: 'editProfile',
          builder: (BuildContext context, GoRouterState state) {
            return BlocProvider(
              create: (_) => sl<ProfileBloc>(),
              child: const EditProfileScreen(),
            );
          },
        ),
         
        GoRoute(
          path: 'history',
          name: 'profileServiceHistory',
          builder: (BuildContext context, GoRouterState state) {
            return BlocProvider(
              create: (_) => sl<HistoryBloc>()..add(LoadHistory(FirebaseAuth.instance.currentUser!.uid)),
              child: const PatientServiceHistoryScreen(),
            );
          },
        ),
        GoRoute(
          path: 'privacy',
          name: 'privacySettings',
          builder: (BuildContext context, GoRouterState state) {
            return BlocProvider(
              create: (_) => sl<ProfileBloc>(),
              child: const PrivacySettingsScreen(),
            );
          },
        ),
        GoRoute(
          path: 'activity-log',
          name: 'activityLog',
          builder: (BuildContext context, GoRouterState state) {
            return BlocProvider(
              create: (_) => sl<ProfileBloc>(),
              child: const ActivityLogScreen(),
            );
          },
        ),
      ],
    ),
  ],
);