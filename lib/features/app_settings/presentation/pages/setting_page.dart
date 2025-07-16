// features/home/presentation/widgets/settings_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/core/utils/logger.dart';
import 'package:flutter_starter_kit/features/app_settings/provider/settings_provider.dart';

/// Flutter setting page
class SettingsPage extends ConsumerWidget {
  /// flutter setting constructor
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSettings = ref.watch(settingsControllerProvider).themeMode;
    final isDarkMode =
        ref.watch(settingsControllerProvider).themeMode == ThemeMode.dark;
    AppLogger.debug(asyncSettings.name);
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
        // Other settings...
      ],
    );
  }
}
