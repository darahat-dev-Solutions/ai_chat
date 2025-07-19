import 'package:flutter_localization/flutter_localization.dart';

///Singleton instance to manage app localization.
final FlutterLocalization localization = FlutterLocalization.instance;

/// Contains locale identifiers and translation keys used across the application
mixin AppLocale {
  /// Translation keys
  static const String title = 'title';

  /// Local Identifiers
  static const String enUS = 'en_US';

  /// Local Identifiers
  static const String kmKH = 'km_KH';

  /// Local Identifiers
  static const String jaJA = 'ja_JP';
}

/// Holds translation data for each supported locale.
///
/// Each map inside contains key-value pairs for translated text
class AppLocaleData {
  /// Key value for translation
  static const Map<String, String> enUS = {AppLocale.title: 'Welcome'};

  /// Key value for translation

  static const Map<String, String> kmKH = {AppLocale.title: 'ស្វាគមន៍'};

  /// Key value for translation

  static const Map<String, String> jaJP = {AppLocale.title: 'ようこそ'};
}

/// Maps each locale identifier with its corresponding translation data.
///
/// This is used to initialize the [FlutterLocalization] instance.
final List<MapLocale> mapLocales = [
  MapLocale(AppLocale.enUS, AppLocaleData.enUS),
  MapLocale(AppLocale.kmKH, AppLocaleData.kmKH),
  MapLocale(AppLocale.jaJA, AppLocaleData.jaJP),
];
