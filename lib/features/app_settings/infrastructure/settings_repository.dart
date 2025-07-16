import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/core/constants/hive_constants.dart';
import 'package:flutter_starter_kit/features/app_settings/domain/settings_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Settings Repository class where all get and Save functions will exist
class SettingsRepository {
  static final SettingDefinitionModel _themeModeSettingDefinition =
      SettingDefinitionModel(
        id: 1,
        name: 'ThemeMode',
        description: 'Application theme mode(light, dark, system)',
        defaultValue: ThemeMode.system.name,
        dataType: 'STRING',
        isUserSpecific: false,
      );

  /// Theme Mode get request will hit here and
  Future<String?> getThemeMode() async {
    final Box<SettingDefinitionModel> settingsBox =
        Hive.box<SettingDefinitionModel>(HiveConstants.settingsBoxName);

    /// getting data from app Shared Preferences data
    SettingDefinitionModel? storedDefinition = settingsBox.get(
      _themeModeSettingDefinition.id,
    );
    // If not found, store the default definition
    if (storedDefinition == null) {
      await settingsBox.put(
        _themeModeSettingDefinition.id,
        _themeModeSettingDefinition,
      );
      storedDefinition = _themeModeSettingDefinition;
    } else {
      final Box<String> themeBox = await Hive.openBox<String>('themeSettings');
      return themeBox.get(_themeModeSettingDefinition.name);
    }
    return null;
  }

  /// Save on changed data from app to Shared Preferences data

  Future<void> saveThemeMode(String themeMode) async {
    final Box<SettingDefinitionModel> settingsBox =
        Hive.box<SettingDefinitionModel>(HiveConstants.settingsBoxName);

    /// Ensure the definition exists in the box
    await settingsBox.put(
      _themeModeSettingDefinition.id,
      _themeModeSettingDefinition,
    );

    /// Store the actual theme mode string
    final Box<String> themeBox = await Hive.openBox<String>('themeSettings');
    await themeBox.put(_themeModeSettingDefinition.name, themeMode);
  }
}
