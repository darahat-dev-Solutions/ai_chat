// features/home/presentation/widgets/settings_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/core/utils/logger.dart';
import 'package:flutter_starter_kit/features/app_settings/provider/settings_provider.dart';
import 'package:flutter_starter_kit/l10n/app_localizations.dart';

/// Flutter setting page
class SettingsPage extends ConsumerWidget {
  /// flutter setting constructor
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSettings = ref.watch(settingsControllerProvider);
    final isDarkMode = asyncSettings.themeMode == ThemeMode.dark;
    AppLogger.debug(asyncSettings.themeMode.name);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Appearance',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SwitchListTile(
          title: const Text('Dark Mode'),
          value: isDarkMode,
          onChanged: (value) {
            ref
                .read(settingsControllerProvider.notifier)
                .updateThemeMode(value ? ThemeMode.dark : ThemeMode.light);
          },
        ),
        const SizedBox(height: 20),
        const Text(
          'Language',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        DropdownButton<Locale>(
          value: asyncSettings.locale,
          onChanged: (Locale? newLocale) {
            ref
                .read(settingsControllerProvider.notifier)
                .updateLocale(newLocale);
          },
          items:
              AppLocalizations.supportedLocales.map<DropdownMenuItem<Locale>>((
                Locale locale,
              ) {
                return DropdownMenuItem<Locale>(
                  value: locale,
                  child: Text(locale.languageCode),
                );
              }).toList(),
        ),
      ],
    );
  }
}
