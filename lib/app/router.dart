import 'package:flutter/material.dart'; // Adds BuildContext
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:opsmate/features/auth/presentation/pages/auth_page.dart';
import 'package:opsmate/features/auth/presentation/pages/signup_page.dart';
import 'package:opsmate/features/tasks/presentation/pages/task_dashboard.dart';
import 'package:opsmate/splashscreen.dart';

import '../../features/auth/provider/auth_providers.dart';

final router = GoRouter(
  redirect: (BuildContext context, GoRouterState state) {
    final authState = ProviderScope.containerOf(
      context,
    ).read(authControllerProvider);
    final isLoggedIn = authState != null;
    final isSplashScreen = state.matchedLocation == '/';
    final isAuthRoute =
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/register';
    final isTasksRoute = state.matchedLocation == '/tasks';

    // 1. If user is logged in...
    if (isLoggedIn) {
      // Allow splash screen to load (it should quickly redirect to /tasks)
      if (isSplashScreen) return null;

      // Block access to auth routes and redirect to /tasks
      if (isAuthRoute) return '/tasks';

      // Allow access to /tasks
      if (isTasksRoute) return null;
    }
    // 2. If user is NOT logged in...
    else {
      // Allow splash screen and auth routes
      if (isSplashScreen || isAuthRoute) return null;

      // Block access to /tasks and redirect to login
      if (isTasksRoute) return '/login';
    }

    // Default: No redirect needed
    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreenWidget()),
    GoRoute(path: '/login', builder: (context, state) => const AuthScreen()),
    GoRoute(path: '/register', builder: (context, state) => const SignUpPage()),
    GoRoute(path: '/tasks', builder: (context, state) => const TaskDashboard()),
  ],
);
