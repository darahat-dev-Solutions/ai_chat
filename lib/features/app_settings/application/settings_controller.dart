import 'package:ai_chat/core/api/api_service.dart';
import 'package:ai_chat/core/api/api_service_provider.dart';
import 'package:ai_chat/features/app_settings/application/settings_state.dart';
import 'package:ai_chat/features/app_settings/infrastructure/settings_repository.dart';
import 'package:ai_chat/features/app_settings/provider/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A Controller class to manage app setting page.
class SettingsController extends AsyncNotifier<SettingState> {
  /// Required Instances
  late final SettingsRepository _settingsRepository;
  late final ApiService _apiService;

  /// The `build` method is called once when the notifier is first created.
  /// It should return a Future that resolves to the initial state.
  @override
  Future<SettingState> build() async {
    /// Initialize repositories and service
    _settingsRepository = ref.watch(settingsRepositoryProvider);
    _apiService = ref.watch(apiServiceProvider);

    /// locally Saved theme mode value
    final themeModeString = await _settingsRepository.getThemeMode();

    /// locally Saved locale value
    final localeString = await _settingsRepository.getLocale();

    /// Load Ai Chat Module from API
    final aiChatModules = await _apiService.getAiChatModules();

    /// locally Saved AI Chat Module ID
    final selectedAiChatModuleId =
        await _settingsRepository.getAiChatModuleId();

    /// Theme mode instance
    ThemeMode themeMode;

    /// Based on themeModeString value set the ThemeMode
    switch (themeModeString) {
      case 'light':
        themeMode = ThemeMode.light;
        break;
      case 'dark':
        themeMode = ThemeMode.dark;
      default:
        themeMode = ThemeMode.light;
    }

    /// declare locale instance
    Locale? locale;

    /// Based on localeString value set the locale
    if (localeString != null) {
      locale = Locale(localeString);
    } else {
      /// Fallback to a default locale if none is saved
      locale = const Locale('en');
    }

    /// Store the data set of setting to state
    return SettingState(
      themeMode: themeMode,
      locale: locale,
      aiChatModules: aiChatModules,
      selectedAiChatModuleId: selectedAiChatModuleId,
    );
  }

  /// Update Theme mode
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null || newThemeMode == state.value?.themeMode) {
      return; // Do not perform  any work if new and old value are the same or new value is null
    }

    ///Otherwise, update the state and persist the new value
    state = AsyncData(state.value!.copyWith(themeMode: newThemeMode));

    /// Persist the value
    await _settingsRepository.saveThemeMode(newThemeMode.name);
  }

  /// Update Locale controller function
  Future<void> updateLocale(Locale? newLocale) async {
    if (newLocale == null || newLocale == state.value?.locale) {
      return;
    }

    ///Otherwise, update the state and persist the new value
    ///
    ///Update the state optimistically
    state = AsyncData(state.value!.copyWith(locale: newLocale));

    /// persist the new value
    await _settingsRepository.saveLocale(newLocale.languageCode);
  }

  /// Update AI Chat Module
  Future<void> updateAiChatModule(int? newAiChatModuleId) async {
    if (newAiChatModuleId == null ||
        newAiChatModuleId == state.value?.selectedAiChatModuleId) {
      return; // Do not perform  any work if new and old value are the same or new value is null
    }

    /// Otherwise, Update the state and persist the new value
    state = AsyncData(
        state.value!.copyWith(selectedAiChatModuleId: newAiChatModuleId));

    /// Persist the new value
    await _settingsRepository.saveAiChatModuleId(newAiChatModuleId);
  }
}
