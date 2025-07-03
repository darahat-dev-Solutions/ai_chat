import 'package:flutter/material.dart';
import 'package:opsmate/app/theme/app_colors.dart';

/// The light theme configuration used throughout the application.
///
/// This theme includes color and style definitions optimized for light mode UI.
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  // Primary colors
  primaryColor: AppColor.primary,
  scaffoldBackgroundColor: AppColor.background,

  // App Bar Theme
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColor.primary,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: AppColor.buttonText,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),

  // Color scheme for Material 3
  colorScheme: const ColorScheme.light(
    primary: AppColor.primary,
    onPrimary: AppColor.buttonText,
    secondary: AppColor.accent,
    onSecondary: Colors.white,
    surface: AppColor.background,
    onSurface: AppColor.textPrimary,
    error: AppColor.error,
  ),
  //Card Theme
  cardTheme: CardThemeData(
    color: AppColor.surface,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  // Elevated button theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColor.accent,
      foregroundColor: AppColor.buttonText,
      elevation: 2,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  // Text theme
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      color: AppColor.textPrimary,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      color: AppColor.textPrimary,
      fontSize: 28,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: TextStyle(
      color: AppColor.textPrimary,
      fontSize: 22,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      color: AppColor.textPrimary,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(color: AppColor.textPrimary, fontSize: 16),
    bodyMedium: TextStyle(color: AppColor.textSecondary, fontSize: 14),
    labelLarge: TextStyle(
      color: AppColor.buttonText,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColor.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColor.textSecondary),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),

      borderSide: const BorderSide(color: AppColor.textSecondary),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColor.accent, width: 2),
    ),
  ),
);

/// The dark theme configuration used throughout the application.
///
/// This theme includes color and style definitions optimized for dark mode UI.
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  // Primary colors
  primaryColor: AppColor.primaryDark,
  scaffoldBackgroundColor: AppColor.darkBackground,

  // App Bar Theme
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColor.darkAppBar,
    foregroundColor: AppColor.darkTextPrimary,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: AppColor.darkTextPrimary,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),

  // Color scheme for Material 3
  colorScheme: const ColorScheme.dark(
    primary: AppColor.accent,
    onPrimary: AppColor.buttonText,
    secondary: AppColor.accentLight,
    surface: AppColor.darkSurface,
    onSurface: AppColor.darkTextPrimary,
    error: AppColor.error,
  ),

  cardTheme: CardThemeData(
    color: AppColor.darkSurface,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  // Elevated button theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColor.accent,
      foregroundColor: AppColor.buttonText,
      elevation: 2,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  // Text theme
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      color: AppColor.darkTextPrimary,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      color: AppColor.darkTextPrimary,
      fontSize: 28,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: TextStyle(
      color: AppColor.darkTextPrimary,
      fontSize: 22,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      color: AppColor.darkTextPrimary,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(color: AppColor.darkTextPrimary, fontSize: 16),
    bodyMedium: TextStyle(color: AppColor.darkTextSecondary, fontSize: 14),
    labelLarge: TextStyle(
      color: AppColor.buttonText,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColor.darkSurface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColor.darkTextSecondary),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColor.darkTextSecondary),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColor.accent, width: 2),
    ),
  ),
);
