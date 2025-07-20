import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/app/router.dart';
import 'package:flutter_starter_kit/app/theme/app_theme.dart';
import 'package:flutter_starter_kit/core/localization/app_localization.dart';
import 'package:flutter_starter_kit/features/app_settings/provider/settings_provider.dart';
import 'package:flutter_starter_kit/l10n/app_localizations.dart';

/// App is Main material app which called to main and assigned themes router configuration and debug show checked mode value
class App extends ConsumerWidget {
  /// Creates an instance of [App]
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final settings = ref.watch(settingsControllerProvider);

    return MaterialApp.router(
      title: 'FlutterStarterKit',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: settings.themeMode,
      locale: settings.locale, // e.g., for Japanese
      // supportedLocales: const [
      //   Locale('en'),
      //   Locale('km'),
      //   Locale('ja'),
      //   Locale('es'),
      // ],
      // supportedLocales: AppLocale.flutterSupportedLocales,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        ...localization.localizationsDelegates,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return const Locale('en', 'US');
      },
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
