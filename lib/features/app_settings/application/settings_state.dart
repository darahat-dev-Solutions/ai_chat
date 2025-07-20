import 'package:flutter/material.dart';

/// Setting State class
class SettingState {
  ///ThemeMode Describes which theme will used
  final ThemeMode themeMode;

  /// locale describes which language will used
  final Locale locale;

  /// SettingState class constructor
  const SettingState({
    this.themeMode = ThemeMode.light,
    this.locale = const Locale('en'),
  });

  /// copyWith make an copy of the themeMode instance and help to update an object
  SettingState copyWith({ThemeMode? themeMode, Locale? locale}) {
    return SettingState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }
}
