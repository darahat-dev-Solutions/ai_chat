import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:opsmate/features/auth/domain/user_model.dart';

/// Base class representing the authentication state.
///
/// Extend this to represent specific authentication states such as
/// [AuthInitial], [AuthLoading], [Authenticated], [Unauthenticated], and [AuthError].
@immutable
abstract class AuthState {
  /// Const constructor for [AuthState].
  const AuthState();
}

/// Represents the initial state before any authentication action occurs.
class AuthInitial extends AuthState {
  /// Const constructor for [AuthInitial].
  const AuthInitial();
}

/// Represents the loading state during an authentication process.
class AuthLoading extends AuthState {
  /// Const constructor for [AuthLoading].
  const AuthLoading();
}

/// Represents a successfully authenticated user.
///
/// Contains the [User] object returned by Firebase.
class Authenticated extends AuthState {
  /// The authenticated Firebase [User].
  final UserModel user;

  /// Const constructor for [Authenticated] state with the given [user].
  const Authenticated(this.user);
}

/// Represents a state where the user is not authenticated.
class Unauthenticated extends AuthState {
  /// Const constructor for [Unauthenticated].
  const Unauthenticated();
}

/// Represents an authentication failure with an error [message].
class AuthError extends AuthState {
  /// Error message describing the reason for authentication failure.
  final String message;

  /// Const constructor for [AuthError] with a specific error [message].
  const AuthError(this.message);
}

/// Represent a state where the password reset email has been sent
class PasswordResetEmailSent extends AuthState {
  /// Const constructor for [PasswordResetEmailSent] to call it outside
  const PasswordResetEmailSent();
}
