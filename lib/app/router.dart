import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:opsmate/features/auth/application/auth_state.dart';
// Correctly import the page, not the old widget name
import 'package:opsmate/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:opsmate/features/auth/presentation/pages/login_page.dart';
import 'package:opsmate/features/auth/presentation/pages/signup_page.dart';
import 'package:opsmate/features/auth/provider/auth_providers.dart';
import 'package:opsmate/features/home/presentation/pages/home_page.dart';
import 'package:opsmate/splashscreen.dart';

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
        // FIX: Use the correct, const-constructed widget name
        builder: (context, state) => const ForgetPassword(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    ],
    redirect: (context, state) {
      final isAuthenticated = authState is Authenticated;
      final isAuthenticating = authState is AuthLoading;

      // While an auth check is happening, don't redirect.
      // This prevents the user from being flickered between screens.
      if (isAuthenticating) {
        return null;
      }

      final onSplash = state.matchedLocation == '/splash';
      // A user can be on the splash screen while not authenticated.
      if (onSplash) {
        return null;
      }

      // Group all public routes together.
      final onPublicRoutes =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/forget_password';

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
