import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/features/auth/application/auth_state.dart';
// Correctly import the page, not the old widget name
import 'package:flutter_starter_kit/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:flutter_starter_kit/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_starter_kit/features/auth/presentation/pages/signup_page.dart';
import 'package:flutter_starter_kit/features/auth/provider/auth_providers.dart';
import 'package:flutter_starter_kit/features/home/presentation/pages/home_page.dart';
import 'package:flutter_starter_kit/splashscreen.dart';
import 'package:go_router/go_router.dart';

/// This provider is used to control the splash screen duration.
final initializationProvider = FutureProvider<void>((ref) async {
  // This is where you could do other async initialization
  // while the splash screen is showing.
  await Future.delayed(const Duration(seconds: 3));
});

/// This provider is used to create the GoRouter instance.

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreenWidget(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/forget_password',
        builder: (context, state) => ForgetPassword(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    ],
    redirect: (context, state) {
      // We watch the initialization provider to ensure the splash screen is shown for at least 3 seconds.
      final isInitialized = ref.watch(initializationProvider).hasValue;

      final isAuthenticated = authState is Authenticated;
      final isAuthenticating = authState is AuthLoading;

      final onSplash = state.matchedLocation == '/splash';

      // If the app is not initialized yet, stay on the splash screen.
      if (!isInitialized) {
        return onSplash ? null : '/splash';
      }

      // Group all public routes together.
      final onPublicRoutes =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/forget_password';

      // After initialization, if the user is on the splash screen, redirect them.
      if (onSplash) {
        return isAuthenticated ? '/home' : '/login';
      }

      // If the user is logged in, they should not be able to access public routes.
      // Redirect them to the home page.
      if (isAuthenticated && onPublicRoutes) {
        return '/home';
      }

      // If the user is NOT logged in and is trying to access a protected page,
      // redirect them to the login page.
      if (!isAuthenticated && !onPublicRoutes) {
        return '/login';
      }

      // No redirect is needed.
      return null;
    },
  );
});
