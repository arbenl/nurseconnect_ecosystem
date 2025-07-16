import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nurseconnect_admin/dashboard/dashboard_screen.dart';
import 'package:nurseconnect_admin/user_management/user_detail_screen.dart';
import 'package:nurseconnect_admin/user_management/user_management_screen.dart';
import 'package:nurseconnect_admin/shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/dashboard',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/user-management',
          builder: (context, state) => const UserManagementScreen(),
        ),
        GoRoute(
          path: '/user-detail/:collectionName/:userId',
          builder: (context, state) {
            final userId = state.pathParameters['userId']!;
            final collectionName = state.pathParameters['collectionName']!;
            return UserDetailScreen(
              userId: userId,
              collectionName: collectionName,
            );
          },
        ),
      ],
    ),
  ],
);
