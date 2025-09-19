import 'package:hive/hive.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 3)

/// Represents the metadata and definition of a setting
/// This module is designed for store single value data like light or dark, any kind of id, yes or no type data
class SettingDefinitionModel {
  /// setting definition id
  @HiveField(0)
  final int id;

  /// setting definition name
  @HiveField(1)
  final String name;

  /// setting description name
  @HiveField(2)
  final String description;

  /// Stored as String], parsed based on dataType
  @HiveField(3)
  final String defaultValue;

  /// setting datatype
  @HiveField(4)
  final String dataType;

  /// is setting userSpecific or not
  @HiveField(5)
  final bool isUserSpecific;

  /// SettingDefinition constructor
  SettingDefinitionModel({
    required this.id,
    required this.name,
    required this.description,
    required this.defaultValue,
    required this.dataType,
    required this.isUserSpecific,
  });
}
