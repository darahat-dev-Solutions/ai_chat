import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

/// Singleton instance to manage app localization.
final FlutterLocalization localization = FlutterLocalization.instance;

/// Contains locale identifiers and translation keys used across the application.
mixin AppLocale {
  static const String title = 'title';

  static const String enUS = 'en_US';
  static const String kmKH = 'km_KH';
  static const String jaJP = 'ja_JP';

  /// Mapping from string keys to actual Locale objects
  static final Map<String, Locale> localeMap = {
    enUS: Locale('en', 'US'),
    kmKH: Locale('km', 'KH'),
    jaJP: Locale('ja', 'JP'),
  };
  static List<Locale> get flutterSupportedLocales => localeMap.values.toList();
}

extension LocalizationHelpers on FlutterLocalization {
  String get currentLocaleString => currentLocale.toString(); // e.g., 'en_US'
}
