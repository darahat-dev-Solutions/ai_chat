import 'package:flutter/material.dart';

/// Home Page State
class HomeState {
  ///variable for bottom navigation tab position
  final int currentTabIndex;

  /// Home State Constructor
  const HomeState({this.currentTabIndex = 0});

  /// Copy HomeState instance for update
  HomeState copyWith({int? currentTabIndex}) {
    return HomeState(currentTabIndex: currentTabIndex ?? this.currentTabIndex);
  }
}

/// Theme State Page
class ThemeState {
  ///variable for Theme Toggle

  final ThemeMode themeMode;

  /// Theme State Constructor
  const ThemeState({this.themeMode = ThemeMode.light});

  /// Copy ThemeState instance for update
  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(themeMode: themeMode ?? this.themeMode);
  }
}
