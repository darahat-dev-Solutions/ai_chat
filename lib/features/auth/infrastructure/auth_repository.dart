import 'package:firebase_auth/firebase_auth.dart';
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
      name: name,
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
        return null;
      }
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final cred = await _auth.signInWithCredential(credential);

      return UserModel(uid: cred.user!.uid, email: cred.user!.email!);
    } catch (e) {
      print('Error during google sign-in: $e');
      return null;
    }
  }

  /// model function for logout which will call from controller
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
