import 'package:ai_chat/core/services/hive_service.dart';
import 'package:ai_chat/core/utils/logger.dart';
import 'package:ai_chat/features/app_settings/domain/settings_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Settings Repository class where all get and Save functions will exist
class SettingsRepository {
  /// Using Names directly as keys in the settings box
  static const String _themeModeKey = 'ThemeMode';
  static const String _localKey = 'Locale';
  static const String _aiChatModuleKey = 'AiChatModule';

  /// Default Values
  static const String _defaultThemeMode = 'system';
  static const String _defaultLocale = 'en';
  static const int _defaultAiChatModuleId = 1;
  final AppLogger appLogger = AppLogger();

  final HiveService hiveService;
  Box<SettingDefinitionModel> get _box => hiveService.settingsBox;

  SettingsRepository(this.hiveService);

  /// Retrives the saved theme model
  /// Returns the default theme ('system') if no value is found.
  Future<String> getThemeMode() async {
    // final settingsBox = await Hive.openBox(HiveConstants.settingsBoxName);
    final SettingDefinitionModel? model = _box.get(_themeModeKey);
    return model?.defaultValue ?? _defaultThemeMode;
  }

  /// Saves the selected theme mode.
  Future<void> saveThemeMode(String themeMode) async {
    // final settingsBox = await Hive.openBox(HiveConstants.settingsBoxName);
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
  /// Returns the default chatModule id ('1') if no value is found
  Future<String> getAiChatModuleId() async {
    final SettingDefinitionModel? model = _box.get(_aiChatModuleKey);
    return model?.defaultValue?.toString() ?? _defaultAiChatModuleId.toString();
  }

  /// Saves the selected AI Chat Module.
  Future<void> saveAiChatModuleId(int id) async {
    // final settingsBox = await Hive.openBox(HiveConstants.settingsBoxName);
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

  // static final SettingDefinitionModel _themeModeSettingDefinition =
  //     SettingDefinitionModel(
  //   id: 1,
  //   name: 'ThemeMode',
  //   description: 'Application theme mode(light, dark, system)',
  //   defaultValue: ThemeMode.system.name,
  //   dataType: 'STRING',
  //   isUserSpecific: false,
  // );
  // static final SettingDefinitionModel _localeSettingDefinition =
  //     SettingDefinitionModel(
  //   id: 2,
  //   name: 'Locale',
  //   description: "Application language",
  //   defaultValue: 'en',
  //   dataType: 'STRING',
  //   isUserSpecific: false,
  // );
  // static final SettingDefinitionModel _aiChatModuleSettingDefinition =
  //     SettingDefinitionModel(
  //   id: 3,
  //   name: 'AiChatModule',
  //   description:
  //       "AIChat Module like (Math Solver, SQL Query Generator, API Tester)",
  //   defaultValue: 'GeneralAIAssistant',
  //   dataType: 'STRING',
  //   isUserSpecific: false,
  // );

  // /// Theme Mode get request will hit here and
  // Future<String?> getThemeMode() async {
  //   final Box<SettingDefinitionModel> settingsBox =
  //       Hive.box<SettingDefinitionModel>(HiveConstants.settingsBoxName);

  //   /// getting data from app Shared Preferences data
  //   SettingDefinitionModel? storedDefinition = settingsBox.get(
  //     _themeModeSettingDefinition.id,
  //   );
  //   // If not found, store the default definition
  //   if (storedDefinition == null) {
  //     await settingsBox.put(
  //       _themeModeSettingDefinition.id,
  //       _themeModeSettingDefinition,
  //     );
  //     storedDefinition = _themeModeSettingDefinition;
  //   } else {
  //     final Box<String> themeBox = await Hive.openBox<String>('themeSettings');
  //     return themeBox.get(_themeModeSettingDefinition.name);
  //   }
  //   return null;
  // }

  // /// Save on changed data from app to Shared Preferences data

  // Future<void> saveThemeMode(String themeMode) async {
  //   final Box<SettingDefinitionModel> settingsBox =
  //       Hive.box<SettingDefinitionModel>(HiveConstants.settingsBoxName);

  //   /// Ensure the definition exists in the box
  //   await settingsBox.put(
  //     _themeModeSettingDefinition.id,
  //     _themeModeSettingDefinition,
  //   );

  //   /// Store the actual theme mode string
  //   final Box<String> themeBox = await Hive.openBox<String>('themeSettings');
  //   await themeBox.put(_themeModeSettingDefinition.name, themeMode);
  // }

  // /// Theme Mode get request will hit here and
  // Future<String?> getLocale() async {
  //   final Box<SettingDefinitionModel> settingsBox =
  //       Hive.box<SettingDefinitionModel>(HiveConstants.settingsBoxName);

  //   /// getting data from app Shared Preferences data
  //   SettingDefinitionModel? storedDefinition = settingsBox.get(
  //     _localeSettingDefinition.id,
  //   );
  //   // If not found, store the default definition
  //   if (storedDefinition == null) {
  //     await settingsBox.put(
  //       _localeSettingDefinition.id,
  //       _localeSettingDefinition,
  //     );
  //     storedDefinition = _localeSettingDefinition;
  //   } else {
  //     final Box<String> localeBox = await Hive.openBox<String>(
  //       'localeSettings',
  //     );
  //     return localeBox.get(_localeSettingDefinition.name);
  //   }
  //   return null;
  // }

  // /// Save on changed data from app to Shared Preferences data

  // Future<void> saveLocale(String locale) async {
  //   final Box<SettingDefinitionModel> settingsBox =
  //       Hive.box<SettingDefinitionModel>(HiveConstants.settingsBoxName);

  //   /// Ensure the definition exists in the box
  //   await settingsBox.put(
  //     _localeSettingDefinition.id,
  //     _localeSettingDefinition,
  //   );

  //   /// Store the actual theme mode string
  //   final Box<String> localeBox = await Hive.openBox<String>('localeSettings');
  //   await localeBox.put(_localeSettingDefinition.name, locale);
  // }

  // //TODO:
  // ///AI Chat Module(Act like Math Solver, SQL query Generator, api Tester)

  // Future<String?> getAiChatModule() async {
  //   final Box<SettingDefinitionModel> settingsBox =
  //       Hive.box<SettingDefinitionModel>(HiveConstants.settingsBoxName);

  //   /// getting data from app Shared Preferences data
  //   SettingDefinitionModel? storedDefinition = settingsBox.get(
  //     _aiChatModuleSettingDefinition.id,
  //   );
  //   // If not found, store the default definition
  //   if (storedDefinition == null) {
  //     await settingsBox.put(
  //       _aiChatModuleSettingDefinition.id,
  //       _aiChatModuleSettingDefinition,
  //     );
  //     storedDefinition = _aiChatModuleSettingDefinition;
  //   } else {
  //     final Box<String> localeBox = await Hive.openBox<String>(
  //       'aiChatModuleSettings',
  //     );
  //     return localeBox.get(_aiChatModuleSettingDefinition.name);
  //   }
  //   return null;
  // }

  // /// Save on changed data from app to Shared Preferences data

  // Future<void> saveAiChatModule(String locale) async {
  //   final Box<SettingDefinitionModel> settingsBox =
  //       Hive.box<SettingDefinitionModel>(HiveConstants.settingsBoxName);

  //   /// Ensure the definition exists in the box
  //   await settingsBox.put(
  //     _aiChatModuleSettingDefinition.id,
  //     _aiChatModuleSettingDefinition,
  //   );

  //   /// Store the actual theme mode string
  //   final Box<String> localeBox =
  //       await Hive.openBox<String>('aiChatModuleSettings');
  //   await localeBox.put(_aiChatModuleSettingDefinition.name, locale);
  // }
}
