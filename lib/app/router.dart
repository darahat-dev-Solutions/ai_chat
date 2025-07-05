import 'package:flutter/material.dart'; // Adds BuildContext
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:opsmate/features/auth/presentation/pages/auth_page.dart';
import 'package:opsmate/features/auth/presentation/pages/signup_page.dart';
import 'package:opsmate/features/home/presentation/pages/home_page.dart';
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
    final isHomeRoute = state.matchedLocation == '/home';

    // 1. If user is logged in...
    if (isLoggedIn) {
      // Allow splash screen to load (it should quickly redirect to /home)
      if (isSplashScreen) return null;

      // Block access to auth routes and redirect to /home
      if (isAuthRoute) return '/home';

      // Allow access to /home
      if (isHomeRoute) return null;
    }
    // 2. If user is NOT logged in...
    else {
      // Allow splash screen and auth routes
      if (isSplashScreen || isAuthRoute) return null;

      // Block access to /home and redirect to login
      if (isHomeRoute) return '/login';
    }

    // Default: No redirect needed
    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreenWidget()),
    GoRoute(path: '/login', builder: (context, state) => const AuthScreen()),
    GoRoute(path: '/register', builder: (context, state) => const SignUpPage()),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
  ],
);
