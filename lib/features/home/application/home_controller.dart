import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_state.dart';

/// Home Page Controller
class HomeController extends StateNotifier<HomeState> {
  /// HomeController constructor
  HomeController() : super(const HomeState());

  /// Change Tab function for when user click on change tab the state will change
  void changeTab(int index) {
    state = state.copyWith(currentTabIndex: index);
  }
}

/// Theme Functionality Controller
class ThemeController extends StateNotifier<ThemeState> {
  /// ThemeController constructor
  ThemeController() : super(const ThemeState());

  /// Change/Toggle theme function when user click on Toggle theme the state will change
  void toggleTheme(bool isDark) {
    state = state.copyWith(
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
    );
  }
}
