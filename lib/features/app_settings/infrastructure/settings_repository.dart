import 'package:ai_chat/core/services/hive_service.dart';
import 'package:ai_chat/features/app_settings/domain/settings_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Settings Core Functionality Connects with real DB
class SettingsRepository {
  /// Using Names directly as keys in the settings box
  static const String _themeModeKey = 'ThemeMode';
  static const String _localKey = 'Locale';
  static const String _aiChatModuleKey = 'AiChatModule';

  /// Default Values
  static const String _defaultThemeMode = 'system';
  static const String _defaultLocale = 'en';
  static const int _defaultAiChatModuleId = 1;

  /// Get Access HiveService Components
  final HiveService getHiveServiceComponents;
  Box<SettingDefinitionModel> get _box => getHiveServiceComponents.settingsBox;

  /// SettingsRepository Constructor
  SettingsRepository(this.getHiveServiceComponents);

  /// Retrives the saved theme model
  Future<String> getThemeMode() async {
    final SettingDefinitionModel? model = _box.get(_themeModeKey);
    return model?.defaultValue ?? _defaultThemeMode;
  }

  /// Saves the selected theme mode.
  Future<void> saveThemeMode(String themeMode) async {
    final SettingDefinitionModel model = SettingDefinitionModel(
      id: 1,
      name: _themeModeKey,
      description: 'Application theme mode(light, dark, system)',
      defaultValue: themeMode,
      dataType: 'STRING',
      isUserSpecific: false,
    );
    return _box.put(_themeModeKey, model);
  }

  /// Retrives the saved Locale
  /// Returns the default locale ('en') if no value is found
  Future<String> getLocale() async {
    final SettingDefinitionModel? model = _box.get(_localKey);
    return model?.defaultValue ?? _defaultLocale;
  }

  Future<void> saveLocale(String locale) async {
    // final settingsBox = await Hive.openBox(HiveConstants.settingsBoxName);
    final SettingDefinitionModel model = SettingDefinitionModel(
      id: 2,
      name: _localKey,
      description: 'Application language',
      defaultValue: locale,
      dataType: 'STRING',
      isUserSpecific: false,
    );
    return _box.put(_localKey, model);
  }

  /// Retrives the saved AiChatModule
  Future<int> getAiChatModuleId() async {
    final SettingDefinitionModel? model = _box.get(_aiChatModuleKey);
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
    return _box.put(_aiChatModuleKey, model);
  }
}
