# Flutter Localization Setup and Riverpod Integration

This document outlines the process of setting up internationalization (i18n) in a Flutter project using `flutter_localizations` and `flutter_gen-l10n`, managing locale state with Riverpod, and addressing common issues encountered during implementation.

## 1. Flutter Localization Basics

Flutter's internationalization relies on `.arb` (Application Resource Bundle) files to define localized messages. The `flutter_gen-l10n` tool generates Dart code from these `.arb` files, providing a convenient way to access translated strings in your application.

## 2. Project Setup

### 2.1. `pubspec.yaml` Configuration

First, ensure your `pubspec.yaml` includes the necessary dependencies and enables Flutter's code generation for localization.

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations: # Required for localization delegates
    sdk: flutter
  # ... other dependencies

flutter:
  uses-material-design: true
  generate: true # Enable Flutter's code generation for localization

  # Localization configuration
flutter_gen:
  l10n:
    arb-dir: lib/l10n # Directory containing your .arb files
    template-arb-file: app_en.arb # The base .arb file (e.g., English)
    output-localization-file: app_localizations.dart # The generated Dart file
    output-class: AppLocalizations # The name of the generated class
    preferred-supported-locales: # List of locales your app supports
      - en
      - km
      - ja
      - es
```

### 2.2. `.arb` File Structure

All your `.arb` files for different languages should reside directly within the `arb-dir` specified in `pubspec.yaml` (e.g., `lib/l10n/`).

For example:
```
lib/l10n/
├── app_en.arb
├── app_es.arb
├── app_ja.arb
└── app_km.arb
```

Each `.arb` file is a JSON file. The `template-arb-file` (e.g., `app_en.arb`) defines all the keys, and other language files provide translations for those keys.

**Example `app_en.arb` content:**
```json
{
    "@@locale": "en",
    "appTitle": "Flutter Starter Kit",
    "signInToContinue": "Sign in to continue",
    "email": "Email",
    "home": "Home",
    "darkMode": "Dark Mode"
}
```

### 2.3. Generating Localization Code

After configuring `pubspec.yaml` and creating your `.arb` files, run the following command in your project's root directory:

```bash
flutter gen-l10n
```

This command will generate `app_localizations.dart` (and other related files) in your `lib/l10n/` directory. This file contains the `AppLocalizations` class, which you'll use to access your translated strings.

## 3. Managing Locale State with Riverpod

To allow users to change the application's language dynamically, we can manage the `Locale` state using Riverpod.

### 3.1. Define the Locale State and Controller

Create a Riverpod `StateNotifierProvider` to hold and update the current `Locale`.

**File:** `lib/features/app_settings/provider/settings_provider.dart` (or similar)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a SettingsState to hold both theme and locale
class SettingsState {
  final ThemeMode themeMode;
  final Locale locale;

  SettingsState({required this.themeMode, required this.locale});

  SettingsState copyWith({ThemeMode? themeMode, Locale? locale}) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }
}

// StateNotifier to manage settings
class SettingsController extends StateNotifier<SettingsState> {
  SettingsController() : super(SettingsState(themeMode: ThemeMode.system, locale: const Locale('en'))); // Default locale

  void updateThemeMode(ThemeMode newThemeMode) {
    state = state.copyWith(themeMode: newThemeMode);
  }

  void updateLocale(Locale? newLocale) {
    if (newLocale != null) {
      state = state.copyWith(locale: newLocale);
    }
  }
}

// Provider for the SettingsController
final settingsControllerProvider = StateNotifierProvider<SettingsController, SettingsState>(
  (ref) => SettingsController(),
);
```

### 3.2. Integrate with `MaterialApp`

In your main `App` widget, use the Riverpod provider to set the `locale` and `themeMode` of your `MaterialApp`.

**File:** `lib/app.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/app/router.dart';
import 'package:flutter_starter_kit/app/theme/app_theme.dart';
import 'package:flutter_starter_kit/features/app_settings/provider/settings_provider.dart';
import 'package:flutter_starter_kit/l10n/app_localizations.dart'; // Import generated localizations

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final settings = ref.watch(settingsControllerProvider);

    return MaterialApp.router(
      title: 'FlutterStarterKit', // Static title for OS task switcher
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: settings.themeMode,
      locale: settings.locale, // Use locale from Riverpod state
      supportedLocales: AppLocalizations.supportedLocales, // From generated file
      localizationsDelegates: const [
        AppLocalizations.delegate, // From generated file
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return const Locale('en'); // Fallback to English if no match
      },
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
```

### 3.3. Usage in Widgets

Access translated strings using `AppLocalizations.of(context)!` and update the locale via the `SettingsController`.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/features/app_settings/provider/settings_provider.dart';
import 'package:flutter_starter_kit/l10n/app_localizations.dart'; // Import generated localizations

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSettings = ref.watch(settingsControllerProvider);

    return Column(
      children: [
        Text(AppLocalizations.of(context)!.language), // Access translated string

        DropdownButton<Locale>(
          value: asyncSettings.locale,
          onChanged: (Locale? newLocale) {
            ref.read(settingsControllerProvider.notifier).updateLocale(newLocale); // Update locale
          },
          items: AppLocalizations.supportedLocales.map<DropdownMenuItem<Locale>>(
            (Locale locale) {
              return DropdownMenuItem<Locale>(
                value: locale,
                child: Text(locale.languageCode),
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
```

## 4. Common Issues and Solutions

### 4.1. `FormatException: Unexpected character` in `.arb` file

**Problem:**
This error occurs when your `.arb` JSON file has a syntax error, most commonly a missing comma after a key-value pair, or an extra character. The error message usually points to the line *after* the actual problem.

```
FormatException: Unexpected character (at line X, character Y)
        "someKey": "Some Value"  <-- Error points here, but problem is above
        "anotherKey": "Another Value"
```

**Solution:**
Carefully review the `.arb` file at and around the indicated line number. Ensure:
*   Every key-value pair (except the very last one in an object) is followed by a comma.
*   There are no stray characters.
*   All strings are properly quoted.
*   The JSON structure is valid (e.g., all braces and brackets are matched).
It's often safest to replace the entire file content with a known good JSON structure if you suspect deep corruption.

### 4.2. `Null check operator used on a null value` for `AppLocalizations.of(context)!`

**Problem:**
This error typically occurs when `AppLocalizations.of(context)` is called with a `BuildContext` that does not yet have access to the `AppLocalizations` instance. This often happens in the `MaterialApp`'s `title` property or very early in the widget tree's lifecycle.

```dart
// In lib/app.dart
MaterialApp.router(
  title: AppLocalizations.of(context)!.appTitle, // <-- Error here
  // ...
);
```

**Solution:**
The `title` property of `MaterialApp` is primarily for the operating system's task switcher and does not require localization via `BuildContext`. Change it to a static string. Localized titles for `AppBar`s or other UI elements should be handled within widgets that are descendants of `MaterialApp`.

```dart
// In lib/app.dart
MaterialApp.router(
  title: 'Your App Name', // Use a static string here
  // ...
);
```

### 4.3. `flutter gen-l10n` only processes `template-arb-file` (Multi-file `.arb` structure)

**Problem:**
If you organize your `.arb` files into multiple files per language (e.g., `auth_en.arb`, `home_en.arb`, `settings_en.arb`) and set `template-arb-file` to only one of them (e.g., `auth_en.arb`), `flutter gen-l10n` will only generate localization keys from that single file and its corresponding translations. You won't be able to access strings from other `.arb` files via `AppLocalizations.of(context)!`.

**Solution:**
The `flutter gen-l10n` tool expects a single, consolidated `.arb` file for each language. To maintain your modular `.arb` file structure while still generating a single `AppLocalizations` class, you need a pre-build step to merge these files.

**Steps:**
1.  **Keep your individual `.arb` files** (e.g., `auth_en.arb`, `home_en.arb`, etc.) in `lib/l10n/`.
2.  **Create a Python script** (e.g., `merge_arb.py` in your project root) to read all these individual `.arb` files for a given language, merge their contents, and write them to a single `app_en.arb` (and `app_es.arb`, etc.) file in `lib/l10n/`.

    ```python
    # merge_arb.py (example content)
    import json
    import os

    def merge_arb_files(input_dir, languages):
        for lang in languages:
            merged_data = {"@@locale": lang}
            arb_files = [f"auth_{lang}.arb", f"home_{lang}.arb", f"settings_{lang}.arb", f"tasks_{lang}.arb"] # List all your individual files

            for arb_file in arb_files:
                file_path = os.path.join(input_dir, arb_file)
                if os.path.exists(file_path):
                    with open(file_path, 'r', encoding='utf-8') as f:
                        data = json.load(f)
                        for key, value in data.items():
                            if key != "@@locale":
                                merged_data[key] = value
            
            output_file_path = os.path.join(input_dir, f"app_{lang}.arb") # Output to app_en.arb, app_es.arb etc.
            with open(output_file_path, 'w', encoding='utf-8') as f:
                json.dump(merged_data, f, indent=4, ensure_ascii=False)
            print(f"Merged {lang} ARB files into {output_file_path}")

    if __name__ == "__main__":
        l10n_dir = os.path.join(os.path.dirname(__file__), "lib", "l10n")
        languages = ["en", "es", "ja", "km"] 
        merge_arb_files(l10n_dir, languages)
    ```
3.  **Update `pubspec.yaml`** to point `template-arb-file` to the merged `app_en.arb`:

    ```yaml
    flutter_gen:
      l10n:
        arb-dir: lib/l10n
        template-arb-file: app_en.arb # <--- Now points to the merged file
        output-localization-file: app_localizations.dart
        output-class: AppLocalizations
        # ... other settings
    ```
4.  **Run the commands in sequence:**
    ```bash
    python merge_arb.py
    flutter gen-l10n
    ```
    This ensures all your strings are consolidated before code generation.
