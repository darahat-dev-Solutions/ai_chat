import 'package:ai_chat/core/errors/exceptions.dart';
import 'package:ai_chat/core/utils/logger.dart';
import 'package:ai_chat/features/ai_chat/domain/ai_chat_model.dart';
import 'package:ai_chat/features/app_settings/domain/settings_model.dart';
import 'package:ai_chat/features/auth/domain/user_model.dart';
import 'package:ai_chat/features/auth/domain/user_role.dart';
import 'package:ai_chat/features/tasks/domain/task_model.dart';
import 'package:ai_chat/features/utou_chat/domain/utou_chat_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants/hive_constants.dart';

/// HiveService managing hive initial and hive box close function
///
/// I can be call in main.dart file but we separated it so we can easily test and debug it
///
final hiveServiceProvider = Provider<HiveService>((ref) {
  final logger = ref.watch(appLoggerProvider);
  return HiveService(logger);
});

/// HiveService manages Hive initialization and box access.
class HiveService {
  final AppLogger _appLogger;
  bool _initialized = false;

  /// Constructor receives dependencies.
  HiveService(this._appLogger);

  ///Assigned HiveConstants authBox table names to variable
  static const String authBoxName = HiveConstants.authBox;

  ///Assigned HiveConstants taskBox table names to variable

  static const String taskBoxName = HiveConstants.taskBox;

  ///Assigned HiveConstants aiChatBox table names to variable

  static const String aiChatBoxName = HiveConstants.aiChatBox;

  /// Assigned HiveConstants uTouChatBoxName table name to uTouBoxName variable
  static const String uTouChatBoxName = HiveConstants.uTouChatBox;

  /// Assigned HiveConstants settingsBox table name to settingsBoxName variable
  static const String settingsBoxName = HiveConstants.settingsBoxName;

  /// Initializing function of Hive flutter
  Future<void> init() async {
    if (_initialized) return;

    try {
      await Hive.initFlutter();
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(UserModelAdapter());
      }

      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(TaskModelAdapter());
      }

      if (!Hive.isAdapterRegistered(6)) {
        Hive.registerAdapter(UserRoleAdapter());
      }
      if (!Hive.isAdapterRegistered(3)) {
        // This is for SettingDefinitionModelAdapter
        Hive.registerAdapter(SettingDefinitionModelAdapter());
      }
      if (!Hive.isAdapterRegistered(4)) {
        // Assuming typeId 5 for AiChatModelAdapter
        Hive.registerAdapter(AiChatModelAdapter());
      }
      if (!Hive.isAdapterRegistered(5)) {
        // Assuming typeId 6 for UToUChatModelAdapter
        Hive.registerAdapter(UToUChatModelAdapter());
      }

      await Hive.openBox<UserModel>(authBoxName);
      await Hive.openBox<TaskModel>(taskBoxName);
      await Hive.openBox<AiChatModel>(aiChatBoxName);
      await Hive.openBox<SettingDefinitionModel>(settingsBoxName);
      await Hive.openBox<UToUChatModel>(uTouChatBoxName);

      _initialized = true;
      _appLogger.info(
        '🚀 ~This is an info message from my HiveService init so that Hive service is called',
      );
    } catch (e) {
      _initialized = false;
      throw ServerException(
        '🚀 ~Server error occurrede (hive.service.dart) $e',
      );
    }
  }

  /// Auth box initialized
  Box<UserModel> get authBox {
    _checkInitialized();
    return Hive.box<UserModel>(authBoxName);
  }

  ///taskBox initialized

  Box<TaskModel> get taskBox {
    _checkInitialized();
    return Hive.box<TaskModel>(taskBoxName);
  }

  ///aiChatBox initialized

  Box<AiChatModel> get aiChatBoxInit {
    _checkInitialized();
    return Hive.box<AiChatModel>(aiChatBoxName);
  }

  ///uTouBox initialized

  Box<UToUChatModel> get uTouChatBoxInit {
    _checkInitialized();
    return Hive.box<UToUChatModel>(uTouChatBoxName);
  }

  ///settingsBox initialized
  Box<SettingDefinitionModel> get settingsBox {
    _checkInitialized();
    return Hive.box<SettingDefinitionModel>(settingsBoxName);
  }

  /// check are they initialized or not
  void _checkInitialized() {
    if (!_initialized) throw Exception('HiveService not initialized');
  }

  /// Clear all boxes
  Future<void> clear() async {
    await aiChatBoxInit.clear();
    await uTouChatBoxInit.clear();
  }
}
