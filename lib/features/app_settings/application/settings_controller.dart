import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/features/app_settings/application/settings_state.dart';
import 'package:flutter_starter_kit/features/app_settings/infrastructure/settings_repository.dart';

/// Setting Controller class
class SettingsController extends StateNotifier<SettingState> {
  /// Setting Controller constructor
  SettingsController(this._settingsRepository) : super(const SettingState()) {
    _loadThemeMode();
    _loadLocale();
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

  /// Get Locale update data
  Future<void> _loadLocale() async {
    final localeString = await _settingsRepository.getLocale();
    if (localeString != null) {
      state = state.copyWith(locale: Locale(localeString));
    }
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

  /// Update Locale controller function
  Future<void> updateLocale(Locale? newLocale) async {
    if (newLocale == null) {
      return;
    }

    /// Do not perform any work if new and old ThemeMode are the same
    if (newLocale == state.locale) {
      return;
    }

    ///Otherwise, update the state and persist the new theme mode
    state = state.copyWith(locale: newLocale);
    await _settingsRepository.saveLocale(newLocale.languageCode);
  }
}
