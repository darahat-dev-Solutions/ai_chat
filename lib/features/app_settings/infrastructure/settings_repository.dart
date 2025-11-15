import 'package:ai_chat/core/services/hive_service.dart';
import 'package:ai_chat/features/app_settings/domain/settings_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// A Repository that handles loading and saving user settings to local storage
class SettingsRepository {
  /// Names of Keys to get specific row data
  static const String _themeModeKey = 'ThemeMode';
  static const String _localKey = 'Locale';
  static const String _aiChatModuleKey = 'AiChatModule';

  /// Setting Default Values for GET Functions
  static const String _defaultThemeMode = 'system';
  static const String _defaultLocale = 'en';
  static const int _defaultAiChatModuleId = 1;

  /// The HiveService instance
  final HiveService hiveService;

  /// The internal hive box for setting
  Box<SettingDefinitionModel> get _box => hiveService.settingsBox;

  /// SettingsRepository Constructor
  SettingsRepository(this.hiveService);

  /// Retrieves the saved theme mode
  ///
  /// Returns the default theme (system) if no value is found
  Future<String> getThemeMode() async {
    final SettingDefinitionModel? model = _box.get(_themeModeKey);

    /// if the model exists, return its value; otherwise return the default
    return model?.defaultValue ?? _defaultThemeMode;
  }

  /// Saves the selected theme mode to the box.
  Future<void> saveThemeMode(String themeMode) async {
    final SettingDefinitionModel model = SettingDefinitionModel(
      id: 1,
      name: _themeModeKey,
      description: 'Application theme mode(light, dark, system)',
      defaultValue: themeMode,
      dataType: 'STRING',
      isUserSpecific: false,
    );

    /// Save the new model to box, overwriting any existing one
    return _box.put(_themeModeKey, model);
  }

  /// Retrieves the saved Language/Locale value(en,jp etc)
  ///
  /// Returns the default Language/Locale value if no value is found
  Future<String> getLocale() async {
    final SettingDefinitionModel? model = _box.get(_localKey);

    /// if the model exists, return its value; otherwise return the default
    return model?.defaultValue ?? _defaultLocale;
  }

  /// Save the selected Language/Locale value to the box
  Future<void> saveLocale(String locale) async {
    final SettingDefinitionModel model = SettingDefinitionModel(
      id: 2,
      name: _localKey,
      description: 'Application language',
      defaultValue: locale,
      dataType: 'STRING',
      isUserSpecific: false,
    );

    /// Save the new model to box, overwriting any existing one
    return _box.put(_localKey, model);
  }

  /// Retrieves the ID of selected AI Chat Module
  ///
  /// Returns the default AI Module ID if no value found
  Future<int> getAiChatModuleId() async {
    final SettingDefinitionModel? model = _box.get(_aiChatModuleKey);

    /// The default value stored as a string, so it must be parsed
    /// If parse fails or value doesn't exist, fail back to default ID
    return int.tryParse(model?.defaultValue ?? '') ?? _defaultAiChatModuleId;
  }

  /// Saves the selected AI Chat Module.
  Future<void> saveAiChatModuleId(int id) async {
    final SettingDefinitionModel model = SettingDefinitionModel(
      id: 3,
      name: _aiChatModuleKey,
      description: 'AI Chat Module ID',
      defaultValue: id.toString(),
      dataType: 'INT',
      isUserSpecific: false,
    );

    /// Save the new model to box, overwriting any existing one
    return _box.put(_aiChatModuleKey, model);
  }
}
