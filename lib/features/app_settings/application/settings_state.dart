import 'package:ai_chat/features/ai_chat/domain/ai_chat_module.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Represents the user's persisted application settings
///
/// The class is immutable. To update the state, create a new instance
/// using the [copyWith] method.
class SettingState extends Equatable {
  /// The Current Theme mode of the application(e.g., light, dark)
  final ThemeMode themeMode;

  /// The user's selected language
  final Locale locale;

  /// The list of available Ai Chat Modules/Personalities
  final List<AiChatModule> aiChatModules;

  /// The ID of the currently active AI model
  final int selectedAiChatModuleId;

  /// Creates an instance of the settings state, with optional default values.
  const SettingState({
    this.themeMode = ThemeMode.light,
    this.locale = const Locale('en'),
    this.aiChatModules = const [],
    this.selectedAiChatModuleId = 1,
  });

  /// Creates a new [SettingState] instance with updated values
  ///
  /// This is useful for creating a modified copy of the state without
  /// Mutating the original object, which is a best practice for state management.
  SettingState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    List<AiChatModule>? aiChatModules,
    int? selectedAiChatModuleId,
  }) {
    return SettingState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      aiChatModules: aiChatModules ?? this.aiChatModules,
      selectedAiChatModuleId:
          selectedAiChatModuleId ?? this.selectedAiChatModuleId,
    );
  }

  @override
  List<Object?> get props =>
      [themeMode, locale, aiChatModules, selectedAiChatModuleId];
}
