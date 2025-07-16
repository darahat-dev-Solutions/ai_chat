import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/core/utils/logger.dart';
import 'package:flutter_starter_kit/features/app_settings/application/settings_controller.dart';
import 'package:flutter_starter_kit/features/app_settings/application/settings_state.dart';
import 'package:flutter_starter_kit/features/app_settings/infrastructure/settings_repository.dart';

/// its carry all functionality of AuthRepository functions
final settingsRepositoryProvider = Provider((ref) => SettingsRepository());

/// settingsControllerProvider will use for all kind of controller function calling
final settingsControllerProvider =
    StateNotifierProvider<SettingsController, SettingState>((ref) {
      final repo = ref.watch(settingsRepositoryProvider);
      AppLogger.debug('I am from dark mode settingsControllerProvider $repo');

      return SettingsController(repo);
    });
/// Obscure settings provider which will be use in setting