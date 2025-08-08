import 'package:ai_chat/core/errors/exceptions.dart';
import 'package:ai_chat/core/utils/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb; // Make sure to add this import
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
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel(uid: cred.user!.uid, email: cred.user!.email!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw const AuthenticationException(
          '🚀 ~An account already exists with this email. Please sign in using the provider associated with this email address',
        );
      } else {
        /// Handle other Firebase-specific errors
        throw const AuthenticationException('Sign in failed. Please try again');
      }
    } catch (e) {
      throw AuthenticationException(
        '🚀 ~ Email or Password Combination not Match',
      );
    }
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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw const AuthenticationException(
          '🚀 ~An account already exists with this email. Please sign in using the provider associated with this email address',
        );
      } else {
        /// Handle other Firebase-specific errors
        throw const AuthenticationException(
          'Google sign in failed. Please try again',
        );
      }
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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw const AuthenticationException(
          '🚀 ~An account already exists with this email. Please sign in using the provider associated with this email address',
        );
      } else {
        /// Handle other Firebase-specific errors
        throw const AuthenticationException(
          'Github sign in failed. Please try again',
        );
      }
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

  /// OTP send Repository Function
  Future<void> sendOTP(
    String phoneNumber, {
    required Function(String, int?) codeSent,
    Function(String)? codeAutoRetrievalTimeoutCallback,
  }) async {
    AppLogger.debug('🚀send otp called with this number $phoneNumber');

    try {
      AppLogger.debug('🚀send otp called with this number2 $phoneNumber');

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          AppLogger.debug('🚀 Verification completed $codeSent, $credential');
        },
        verificationFailed: (FirebaseAuthException e) {
          AppLogger.debug('🚀 ~Failed to send OTP $e');
          throw AuthenticationException(e.message ?? '🚀 ~Failed to send OTP');
        },
        codeSent: codeSent,
        codeAutoRetrievalTimeout: (String verificationId) {
          AppLogger.debug('🚀 ~Code getting timeout $verificationId');
          codeAutoRetrievalTimeoutCallback?.call(verificationId);
        },
      );
    } catch (e) {
      throw AuthenticationException('🚀 ~Failed to send OTP from cache $e');
    }
  }

  /// Verify OTP auth_Repository Function

  Future<UserModel?> verifyOTP(String verificationId, String smsCode) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final cred = await _auth.signInWithCredential(credential);
      return UserModel(uid: cred.user!.uid, email: cred.user!.email!);
    } catch (e) {
      throw AuthenticationException('🚀 ~Failed to verify OTP');
    }
  }

  /// Resent OTP auth_Repository Function

  Future<void> resendOTP(
    String phoneNumber, {
    required Function(String, int?) codeSent,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw AuthenticationException(e.message ?? 'Failed to send OTP');
        },
        codeSent: codeSent,
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      throw AuthenticationException('Failed to resend OTP');
    }
  }
}
