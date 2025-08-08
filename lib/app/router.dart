import 'package:ai_chat/app/app_route.dart';
import 'package:ai_chat/core/utils/logger.dart';
import 'package:ai_chat/features/auth/application/auth_state.dart';
import 'package:ai_chat/features/auth/domain/user_role.dart';
import 'package:ai_chat/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:ai_chat/features/auth/presentation/pages/login_page.dart';
import 'package:ai_chat/features/auth/presentation/pages/otp_page.dart';
import 'package:ai_chat/features/auth/presentation/pages/phone_number_page.dart';
import 'package:ai_chat/features/auth/presentation/pages/signup_page.dart';
import 'package:ai_chat/features/auth/provider/auth_providers.dart';
import 'package:ai_chat/features/home/presentation/layout/home_layout.dart';
import 'package:ai_chat/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// A helper class to bridge Riverpod's StateNotifier to a ChangeNotifier.
/// This allows GoRouter's `refreshListenable` to react to changes in the
/// authentication state.
class AuthListenable extends ChangeNotifier {
  /// A reference to the Riverpod Ref, used to listen to providers.
  final Ref ref;

  /// Creates an instance of AuthListenable.
  ///
  /// It sets up a listener on the `authControllerProvider` to be notified
  /// of any changes in the authentication state. When a change occurs,
  /// it calls `notifyListeners()` to trigger a UI update.
  AuthListenable(this.ref) {
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      AppLogger.info('AuthState changed: $next');
      notifyListeners();
    });
  }
}

/// This provider is used to control the splash screen duration.
final initializationFutureProvider = FutureProvider<void>((ref) async {
  // This is where you could do other async initialization
  // while the splash screen is showing.
  await Future.delayed(const Duration(seconds: 3));
});

/// This provider is used to create the GoRouter instance.

final routerProvider = Provider<GoRouter>((ref) {
  final authListenable = AuthListenable(ref);

  /// Define your routes using the custom AppRoute
  final routes = [
    AppRoute(
      path: '/splash',
      name: 'splash',
      // Only non-authenticated users (guests) can see the login page.
      allowedRoles: [
        UserRole.guest,
        UserRole.authenticatedUser,
        UserRole.admin,
      ],
      builder: (context, state) => const SplashScreenWidget(),
    ),
    AppRoute(
      path: '/login',
      name: 'login',
      // Only non-authenticated users (guests) can see the login page.
      allowedRoles: [UserRole.guest],
      builder: (context, state) => const LoginPage(),
    ),
    AppRoute(
      path: '/register',
      name: 'register',
      // Only non-authenticated users (guests) can see the login page.
      allowedRoles: [UserRole.guest],
      builder: (context, state) => const SignUpPage(),
    ),
    AppRoute(
      path: '/phone-number',
      name: 'phone-number',
      // Only non-authenticated users (guests) can see the login page.
      allowedRoles: [UserRole.guest],
      builder: (context, state) => const PhoneNumberPage(),
    ),
    AppRoute(
      path: '/otp',
      name: 'otp',
      // Only authenticated users  can see the Home page.
      allowedRoles: [UserRole.guest],
      builder: (context, state) => const OTPPage(),
    ),
    AppRoute(
      path: '/forget_password',
      name: 'forget_password',
      // Only authenticated users  can see the Home page.
      allowedRoles: [UserRole.guest],
      builder: (context, state) => const ForgetPassword(),
    ),
    AppRoute(
      path: '/home',
      name: 'home',
      // Only authenticated users  can see the Home page.
      allowedRoles: [UserRole.authenticatedUser, UserRole.admin],
      builder: (context, state) => const HomeLayout(),
    ),
    // Example of an admin-only route
    // AppRoute(
    //   path: '/admin',
    //   name: 'admin',
    //   builder: (context, state) => const AdminDashboardPage(),
    //   allowedRoles: [UserRole.admin],
    // ),
  ];
  return GoRouter(
    initialLocation: '/splash',
    routes: routes,
    refreshListenable: authListenable,
    redirect: (context, state) {
      // We watch the initialization provider to ensure the splash screen is shown for at least 3 seconds.
      final isInitialized = ref.watch(initializationFutureProvider).hasValue;

      // If the app is not initialized yet, stay on the splash screen.
      if (!isInitialized) {
        return state.matchedLocation == '/splash' ? null : '/splash';
      }

      /// Determine the user's role and authentication status
      final authState = ref.read(authControllerProvider);
      final (userRole, isAuthenticated) = switch (authState) {
        Authenticated(user: final user) => (user.role, true),
        _ => (UserRole.guest, false),
      };

      /// After initialization redirect from splash screen
      if (state.matchedLocation == '/splash') {
        return isAuthenticated ? '/home' : '/login';
      }

      /// Get the route definition for the current location
      /// We need to handle the case where the route might not be in our list
      final route = routes.firstWhere(
        (r) => r.path == state.matchedLocation,
        orElse:
            () => AppRoute(
              path: '/not-found',
              builder: (context, state) => const Scaffold(),
              allowedRoles: [],

              /// No Roles Allowed , will trigger a redirect
            ),
      );

      /// Check if the user's role is allowed for this route
      if (route.allowedRoles.contains(userRole)) {
        return null;
      }

      /// If access is denied, redirect them.
      return isAuthenticated ? '/home' : '/login';
    },
  );
});
