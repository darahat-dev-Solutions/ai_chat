import 'package:hive_flutter/hive_flutter.dart';

import '../../features/auth/domain/user_model.dart';
import '../../features/tasks/domain/task_model.dart';
import '../constants/hive_constants.dart';

/// HiveService managing hive initial and hive box close function
///
/// I can be call in main.dart file but we separated it so we can easily test and debug it
class HiveService {
  ///Assigned HiveConstants authBox table names to variable
  static const String authBoxName = HiveConstants.authBox;

  ///Assigned HiveConstants taskBox table names to variable

  static const String taskBoxName = HiveConstants.taskBox;

  static bool _initialized = false;

  /// Initializing function of Hive flutter
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

  /// Close Hive boxes function if there any need to close Hive boxes
  // static Future<void> _closeAllBoxes() async {
  //   try {
  //     if (Hive.isBoxOpen(authBoxName)) await Hive.box(authBoxName).close();
  //     if (Hive.isBoxOpen(taskBoxName)) await Hive.box(taskBoxName).close();
  //   } catch (_) {}
  // }
  /// Auth box initialized
  static Box<UserModel> get authBox {
    _checkInitialized();
    return Hive.box<UserModel>(authBoxName);
  }

  ///taskBox initialized

  static Box<TaskModel> get taskBox {
    _checkInitialized();
    return Hive.box<TaskModel>(taskBoxName);
  }

  /// check are they initialized or not
  static void _checkInitialized() {
    if (!_initialized) throw Exception('HiveService not initialized');
  }
}
