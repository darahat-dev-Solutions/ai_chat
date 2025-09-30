import 'package:ai_chat/core/api/api_service.dart';
import 'package:ai_chat/core/api/api_service_provider.dart';
import 'package:ai_chat/features/ai_chat/domain/ai_chat_module.dart';
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

    /// Load Ai Chat Module from API with error handling
    List<AiChatModule> aiChatModules;
    try {
      aiChatModules = await _apiService.getAiChatModules();
    } catch (e) {
      // If API fails, provide empty list or default modules
      // This prevents the app from crashing when the server is unavailable
      aiChatModules = [];
      // Log the error for debugging
      print('Failed to load AI chat modules: $e');
    }

    /// locally Saved AI Chat Module ID
    int selectedAiChatModuleId = await _settingsRepository.getAiChatModuleId();

    /// If no modules loaded and selected ID is invalid, use default
    if (aiChatModules.isEmpty && selectedAiChatModuleId > 0) {
      selectedAiChatModuleId = 1; // Use default from SettingState
    }

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

    /// Store the data set of setting to state
    return SettingState(
      themeMode: themeMode,
      locale: Locale(localeString),
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
