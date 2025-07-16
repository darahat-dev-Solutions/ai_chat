import 'package:flutter/material.dart';

/// Setting State class
class SettingState {
  ///ThemeMode Describes which theme will used
  final ThemeMode themeMode;

  /// SettingState class constructor
  const SettingState({this.themeMode = ThemeMode.light});

  /// copyWith make an copy of the themeMode instance and help to update an object
  SettingState copyWith({ThemeMode? themeMode}) {
    return SettingState(themeMode: themeMode ?? this.themeMode);
  }
}
