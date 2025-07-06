import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:opsmate/features/auth/application/auth_state.dart';
import 'package:opsmate/features/auth/presentation/pages/login_page.dart';
import 'package:opsmate/features/auth/presentation/pages/signup_page.dart';
import 'package:opsmate/features/auth/provider/auth_providers.dart';
import 'package:opsmate/features/home/presentation/pages/home_page.dart';
import 'package:opsmate/splashscreen.dart';

// 1. Create a provider for your router
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
        path: '/register',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    ],
    redirect: (context, state) {
      // Use the authState to redirect
      final isAuthenticated = authState is Authenticated;
      final isAuthenticating = authState is AuthLoading;

      final onLoginPage = state.matchedLocation == '/login';
      final onRegisterPage = state.matchedLocation == '/register';
      final onSplashPage = state.matchedLocation == '/splash';

      // If the user is on the splash screen, let them stay there.
      // The SplashScreen itself should handle navigating away after a delay.
      if (onSplashPage) {
        return null;
      }

      // If the user is authenticated and tries to go to login/register, send them home.
      if (isAuthenticated && (onLoginPage || onRegisterPage)) {
        return '/home';
      }

      // If the user is NOT authenticated and is trying to access a protected page,
      // send them to the login page.
      if (!isAuthenticated && !onLoginPage && !onRegisterPage) {
        return '/login';
      }

      // In all other cases, no redirect is needed.
      return null;
    },
  );
});
