import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/core/errors/exceptions.dart';
import 'package:flutter_starter_kit/core/services/hive_service.dart';

import '../infrastructure/auth_repository.dart';
import 'auth_state.dart';

/// this class is calling auth_repository model functions
///
/// and put user data to hive box and changing state value
class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  // final Box<UserModel> _box = Hive.box<UserModel>('authBox');

  /// constructor so that it can be called from outside
  AuthController(this._authRepository) : super(const AuthInitial());

  /// Check Initial AuthState to check that user is exist or not
  void checkInitialAuthState() {
    final user = HiveService.authBox.get('user');
    if (user != null) {
      state = Authenticated(user);
    } else {
      state = const Unauthenticated();
    }
  }

  /// SignUp controller which is calling auth model functionalities from auth_repository
  ///
  ///
  /// here just put the user to hive box and changing the state value
  Future<void> signUp(String email, String password, String name) async {
    state = const AuthLoading();
    try {
      final user = await _authRepository.signUp(email, password, name);
      if (user != null) {
        HiveService.authBox.put('user', user);
        state = Authenticated(user);
      } else {
        state = const AuthError(
          ' Sign up failed. Please try again.',
          AuthMethod.signup,
        );
      }
    } catch (e) {
      state = AuthError('Sign up failed. Please Try Again', AuthMethod.signup);
    }
  }

  /// SignIn controller which is calling auth model functionalities from auth_repository
  ///
  ///
  /// here just put the user to hive box and changing the state value

  Future<void> signIn(String email, String password) async {
    state = const AuthLoading();
    try {
      final user = await _authRepository.signIn(email, password);
      if (user != null) {
        HiveService.authBox.put('user', user);
        state = Authenticated(user);
      } else {
        state = const AuthError(
          ' Sign in failed. Please try again.',
          AuthMethod.email,
        );
      }
    } catch (e) {
      state = AuthError(e.toString(), AuthMethod.email);
    }
  }

  /// SignInWithGoogle is calling signInWithGoogle auth_repository model function
  ///
  /// set the state and put the user data to hive box
  Future<void> signInWithGoogle() async {
    state = const AuthLoading();
    try {
      final user = await _authRepository.signInWithGoogle();
      if (user != null) {
        HiveService.authBox.put('user', user);
        state = Authenticated(user);
      } else {
        state = const AuthError(
          'Google Sign in failed. Please try again.',
          AuthMethod.google,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        state = const AuthError(
          'An account already exists with this email. Please sign in using the provider associated with this email address',
          AuthMethod.google,
        );
      } else {
        /// Handle other Firebase-specific errors
        state = AuthError(
          e.message ?? 'Github sign in failed. Please try again',
          AuthMethod.google,
        );
      }
    } catch (e) {
      state = AuthError(e.toString(), AuthMethod.google);
    }
  }

  /// SignInWithGithub is calling signInWithGithub auth_repository model function
  ///
  /// set the state and the user data to hive box
  Future<void> signInWithGithub() async {
    state = const AuthLoading();
    try {
      final user = await _authRepository.signInWithGithub();
      if (user != null) {
        HiveService.authBox.put('user', user);
        state = Authenticated(user);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        state = const AuthError(
          'An account already exists with this email. Please sign in using the provider associated with this email address',
          AuthMethod.github,
        );
      } else {
        /// Handle other Firebase-specific errors
        state = AuthError(
          e.message ?? 'Github sign in failed. Please try again',
          AuthMethod.github,
        );
      }
    } catch (e) {
      state = AuthError(e.toString(), AuthMethod.github);
    }
  }

  /// Sends a password reset email and updates the state
  Future<void> sendPasswordResetEmail(String email) async {
    state = const AuthLoading();
    try {
      await _authRepository.sendPasswordResetEmail(email);
      state = const PasswordResetEmailSent();
      Future.delayed(
        const Duration(seconds: 1),
        () => state = const AuthInitial(),
      );
    } catch (e) {
      state = AuthError(
        'Failed to send reset Email . ${e.toString()}',
        AuthMethod.email,
      );
    }
  }

  /// signOut is calling signOut auth_repository model function
  ///
  /// set the state and put the user data to hive box
  Future<void> signOut() async {
    state = const AuthLoading();
    try {
      await _authRepository.signOut();
      await HiveService.authBox.delete('user');
      state = const AuthInitial();
    } catch (e) {
      throw AuthenticationException('Sign Out Failed');
    }
  }
}
