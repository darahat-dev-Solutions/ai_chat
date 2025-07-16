import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/features/app_settings/application/settings_state.dart';
import 'package:flutter_starter_kit/features/app_settings/infrastructure/settings_repository.dart';

/// Setting Controller class
class SettingsController extends StateNotifier<SettingState> {
  /// Setting Controller constructor
  SettingsController(this._settingsRepository) : super(const SettingState()) {
    _loadThemeMode();
  }
  final SettingsRepository _settingsRepository;
  Future<void> _loadThemeMode() async {
    final themeModeString = await _settingsRepository.getThemeMode();
    ThemeMode themeMode;
    switch (themeModeString) {
      case 'light':
        themeMode = ThemeMode.light;
        break;
      case 'dark':
        themeMode = ThemeMode.dark;
      default:
        themeMode = ThemeMode.light;
    }
    state = state.copyWith(themeMode: themeMode);
  }

  /// Update Theme mode controller function
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) {
      return;
    }

    /// Do not perform any work if new and old ThemeMode are the same
    if (newThemeMode == state.themeMode) {
      return;
    }

    ///Otherwise, update the state and persist the new theme mode
    state = state.copyWith(themeMode: newThemeMode);
    await _settingsRepository.saveThemeMode(newThemeMode.name);
  }
}
