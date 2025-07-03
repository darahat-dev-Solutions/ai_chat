import 'package:hive_flutter/hive_flutter.dart';

import '../../features/auth/domain/user_model.dart';
import '../../features/tasks/domain/task_model.dart';

class HiveService {
  static const String authBoxName = 'authbox';
  static const String taskBoxName = 'taskbox';

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    try {
      await Hive.initFlutter();

      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(UserModelAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(TaskModelAdapter());
      }

      await Hive.openBox<UserModel>(authBoxName);
      await Hive.openBox<TaskModel>(taskBoxName);

      _initialized = true;
    } catch (e) {
      _initialized = false;
      rethrow;
    }
  }

  static Future<void> _closeAllBoxes() async {
    try {
      if (Hive.isBoxOpen(authBoxName)) await Hive.box(authBoxName).close();
      if (Hive.isBoxOpen(taskBoxName)) await Hive.box(taskBoxName).close();
    } catch (_) {}
  }

  static Box<UserModel> get authBox {
    _checkInitialized();
    return Hive.box<UserModel>(authBoxName);
  }

  static Box<TaskModel> get taskBox {
    _checkInitialized();
    return Hive.box<TaskModel>(taskBoxName);
  }

  static void _checkInitialized() {
    if (!_initialized) throw Exception('HiveService not initialized');
  }
}
