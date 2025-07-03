import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../domain/user_model.dart';
import '../infrastructure/auth_repository.dart';

/// this class is calling auth_repository model functions
///
/// and put user data to hive box and changin state value
class AuthController extends StateNotifier<UserModel?> {
  final AuthRepository _repo;
  final Box<UserModel> _box = Hive.box<UserModel>('authBox');

  /// constructor so that it can be called from outside
  AuthController(this._repo)
    : super(Hive.box<UserModel>('authBox').get('user'));

  /// SignUp controller which is calling auth model functionalities from auth_repository
  ///
  ///
  /// here just put the user to hive box and changing the state value
  Future<void> signUp(String email, String password, String name) async {
    final user = await _repo.signUp(email, password, name);
    if (user != null) {
      _box.put('user', user);
      state = user;
    }
  }

  /// SignIn controller which is calling auth model functionalities from auth_repository
  ///
  ///
  /// here just put the user to hive box and changing the state value

  Future<void> signIn(String email, String password) async {
    final user = await _repo.signIn(email, password);
    if (user != null) {
      _box.put('user', user);
      state = user;
    }
  }

  /// SignInWithGoogle is calling signInWithGoogle auth_repository model function
  ///
  /// set the state and put the user data to hive box
  Future<void> signInWithGoogle() async {
    final user = await _repo.signInWithGoogle();
    if (user != null) {
      _box.put('user', user);
      state = user;
    }
  }

  /// signOut is calling signOut auth_repository model function
  ///
  /// set the state and put the user data to hive box
  Future<void> signOut() async {
    await _repo.signOut();
    await _box.delete('user');
    state = null;
  }
}
