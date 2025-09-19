import 'package:ai_chat/core/api/api_service.dart';
import 'package:ai_chat/core/api/api_service_provider.dart';
import 'package:ai_chat/features/app_settings/application/settings_state.dart';
import 'package:ai_chat/features/app_settings/infrastructure/settings_repository.dart';
import 'package:ai_chat/features/app_settings/provider/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Setting Controller class
///
/// Manages the application settings
class SettingsController extends AsyncNotifier<SettingState> {
  /// Setting Controller constructor
  late final SettingsRepository _settingsRepository;
  late final ApiService _apiService;

  /// The `build` method is called once when the notifier is first created.
  /// It should return a Future that resolves to the initial state.
  @override
  Future<SettingState> build() async {
    _settingsRepository = ref.watch(settingsRepositoryProvider);
    _apiService = ref.watch(apiServiceProvider);

    ///Inject repository
    ///Load initial theme mode and locale concurrently
    final themeModeString = await _settingsRepository.getThemeMode();
    final localeString = await _settingsRepository.getLocale();
    final aiChatModules = await _apiService.getAiChatModules();
    final selectedAiChatModuleId =
        await _settingsRepository.getAiChatModuleId();

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

    /// Get Locale update data

    Locale? locale;
    if (localeString != null) {
      locale = Locale(localeString);
    } else {
      /// Fallback to a default locale if none is saved
      locale = const Locale('en');
    }

    return SettingState(
      themeMode: themeMode,
      locale: locale,
      aiChatModules: aiChatModules,
      selectedAiChatModuleId: selectedAiChatModuleId,
    );
  }

  /// Update Theme mode controller function
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null || newThemeMode == state.value?.themeMode) {
      return; // Do not perform  any work if new and old themeMode are the same or newThemeMode is null
    }

    ///Otherwise, update the state and persist the new theme mode
    state = AsyncData(state.value!.copyWith(themeMode: newThemeMode));

    /// Persist the new theme mode
    await _settingsRepository.saveThemeMode(newThemeMode.name);
  }

  /// Update Locale controller function
  Future<void> updateLocale(Locale? newLocale) async {
    if (newLocale == null || newLocale == state.value?.locale) {
      return;
    }

    ///Otherwise, update the state and persist the new theme mode
    ///
    ///Update the state optimistically
    state = AsyncData(state.value!.copyWith(locale: newLocale));

    /// persist the new locale
    await _settingsRepository.saveLocale(newLocale.languageCode);
  }

  Future<void> updateAiChatModule(int? newAiChatModuleId) async {
    if (newAiChatModuleId == null ||
        newAiChatModuleId == state.value?.selectedAiChatModuleId) {
      return;
    }

    state = AsyncData(
        state.value!.copyWith(selectedAiChatModuleId: newAiChatModuleId));

    await _settingsRepository.saveAiChatModuleId(newAiChatModuleId);
  }
}
