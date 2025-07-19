import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/app/router.dart';
import 'package:flutter_starter_kit/app/theme/app_theme.dart';
import 'package:flutter_starter_kit/core/localization/app_localization.dart';
import 'package:flutter_starter_kit/features/app_settings/provider/settings_provider.dart';

/// App is Main material app which called to main and assigned themes router configuration and debug show checked mode value
class App extends ConsumerWidget {
  /// Creates an instance of [App]
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(settingsControllerProvider).themeMode;
    return MaterialApp.router(
      title: 'FlutterStarterKit',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      locale: localization.currentLocale,
      supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
