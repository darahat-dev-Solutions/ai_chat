import 'package:ai_chat/features/ai_chat/domain/ai_chat_module.dart';
import 'package:flutter/material.dart';

/// Setting State class to persist User Preferences
class SettingState {
  /// Instance of Theme mode
  final ThemeMode themeMode;

  /// Locale Instance
  final Locale locale;

  /// Ai Chat Modules List Instance
  final List<AiChatModule> aiChatModules;

  /// Selected AI Chat Module ID
  final int selectedAiChatModuleId;

  /// SettingState class constructor with initial
  const SettingState({
    this.themeMode = ThemeMode.light,
    this.locale = const Locale('en'),
    this.aiChatModules = const [],
    this.selectedAiChatModuleId = 1,
  });

  /// CopyWith make an copy of the themeMode instance and help to update an object
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

  /// Overrides the equality operator to compare two settingstate instances by heir values
  ///
  /// This is essential for riverpod (and other state management solutions)
  /// to correctly detect when the state has truly changed. Without this
  /// Riverpod would only compare object references, leading to unnecessary
  /// widget rebuilds or failing to rebuild when the content changes
  ///
  /// Two SettingState objects are considered equal if their 'themeMode'
  /// and locale properties are identical
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true; // Optimization for same object reference
    }
    return other is SettingState && // Ensure other is of the same type
        other.themeMode == themeMode && // Compare themeMode values
        other.locale == locale &&
        other.aiChatModules == aiChatModules &&
        other.selectedAiChatModuleId == selectedAiChatModuleId;

    /// Compare locale values
  }

  /// Overrides the hashcode getter to provide a hash code consistent with operator ==
  /// when operator == is overridden hashcode must also be overritten
  /// this ensures that if two objects are equal according to operator ==
  /// the produce the same has code. this contract is vital for objects
  /// used in has-based collections like set and map keys
  ///
  /// The hash code is computed by combining the hash codes of thememode
  /// and locale
  @override
  int get hashCode =>
      themeMode.hashCode ^
      locale.hashCode ^
      aiChatModules.hashCode ^
      selectedAiChatModuleId.hashCode;
}
