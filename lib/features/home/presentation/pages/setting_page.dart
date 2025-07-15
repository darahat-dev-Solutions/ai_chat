// features/home/presentation/widgets/settings_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/features/home/provider/home_provider.dart';

/// Flutter setting page
class SettingsPage extends ConsumerWidget {
  /// flutter setting constructor
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode =
        ref.watch(themeControllerProvider).themeMode == ThemeMode.dark;

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
            ref.read(themeControllerProvider.notifier).toggleTheme(value);
          },
        ),
        // Other settings...
      ],
    );
  }
}
