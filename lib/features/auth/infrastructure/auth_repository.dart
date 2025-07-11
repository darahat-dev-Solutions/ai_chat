import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb; // Make sure to add this import
import 'package:flutter_starter_kit/core/errors/exceptions.dart';
import 'package:flutter_starter_kit/core/utils/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../domain/user_model.dart';

/// this is the file where auth_controller connect with repositories
class AuthRepository {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  // final _box = Hive.box<UserModel>('authBox');

  /// this is SignUp model function which will call from controller
  Future<UserModel?> signUp(String email, String password, String name) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return UserModel(uid: cred.user!.uid, email: cred.user!.email!);
  }

  /// this is Signin model function which will call from controller
  Future<UserModel?> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return UserModel(uid: cred.user!.uid, email: cred.user!.email!);
  }

  /// This is Signin model function for google signin which will call from controller
  Future<UserModel?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        /// User canceled the sign-in
        throw AuthenticationException('🚀 ~ User Canceled the Sign-in');
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final cred = await _auth.signInWithCredential(credential);

      return UserModel(uid: cred.user!.uid, email: cred.user!.email!);
    } catch (e) {
      AppLogger.error('🚀 ~ Error during Google Sign-in');
      throw AuthenticationException('🚀 ~ Google Sign in failed $e');
    }
  }

  /// This is Signin model function for github signin which will call from controller
  Future<UserModel?> signInWithGithub() async {
    try {
      final githubAuthProvider = GithubAuthProvider();
      UserCredential cred;
      if (kIsWeb) {
        cred = await _auth.signInWithPopup(githubAuthProvider);
      } else {
        cred = await _auth.signInWithProvider(githubAuthProvider);
      }
      return UserModel(uid: cred.user!.uid, email: cred.user!.email!);
    } catch (e) {
      AppLogger.error('🚀 ~ Error during Github Sign-in', e);
      throw const AuthenticationException(
        '🚀 ~Failed to sign in with GitHub. Please try again.',
      );
    }
  }

  /// Sends a password reset email to the given email address
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      AppLogger.error('🚀 ~ sendPasswordResetEmail Error', e);
      throw const AuthenticationException(
        '🚀 ~Failed to send Password Reset Email',
      );
    }
  }

  /// model function for logout which will call from controller
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
