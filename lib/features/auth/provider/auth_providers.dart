import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/auth_controller.dart';
import '../domain/user_model.dart';
import '../infrastructure/auth_repository.dart';

/// its carry all functionality of AuthRepository model functions.
final authRepositoryProvider = Provider((ref) => AuthRepository());

/// authStateProvider will check users recent status and carries User information.
/// AuthStateProvider will use for all kind of calling in controlller
final authControllerProvider =
    StateNotifierProvider<AuthController, UserModel?>((ref) {
      final repo = ref.watch(authRepositoryProvider);
      return AuthController(repo);
    });
