import 'dart:convert';

/// Represents the metadata and definition of a setting
class SettingDefinition {
  /// setting definition id
  final int id;

  /// setting definition name
  final String name;

  /// setting description name
  final String description;

  /// Stored as String], parsed based on dataType

  final String defaultValue;

  /// setting datatype
  final String dataType;

  /// is setting userSpecific or not
  final bool isUserSpecific;

  /// SettingDefinition constructor
  SettingDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.defaultValue,
    required this.dataType,
    required this.isUserSpecific,
  });

  /// Factory constructor to create from a database row map
  factory SettingDefinition.fromMap(Map<String, dynamic> map) {
    return SettingDefinition(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'],
      defaultValue: map['defaultValue'],
      dataType: map['dataType'],
      isUserSpecific: map['isUserSpecific'],
    );
  }
}

/// Represents an actual setting value(either global or user-specific)
/// The type [T]  is the expected type of the setting's value (bool int string, map)
class Setting<T> {
  ///definition instance of SettingDefinition class
  final SettingDefinition definition;

  ///The actual parsed value;

  final T value;

  /// Setting class constructor
  Setting({required this.definition, required this.value});

  /// Helper to parse a string value into the correct type based on dataType
  static dynamic _parseValue(String stringValue, String dataType) {
    switch (dataType) {
      case 'BOOLEAN':
        return stringValue.toLowerCase() == 'true';
      case 'INTEGER':
        return int.tryParse(stringValue);
      case 'DOUBLE':
        return double.tryParse(stringValue);
      case 'JSON':
        try {
          return jsonDecode(stringValue);

          /// handle JSON parsing error , maybe return null or throw
        } catch (e) {
          return null;
        }
      case 'STRING':
      default:
        return stringValue;
    }
  }

  ///Factory constructor for user setting(assuming you fetch definition separately)
  factory Setting.fromUserMap(
    Map<String, dynamic> map,
    SettingDefinition definition,
  ) {
    return Setting<T>(
      definition: definition,
      value: _parseValue(map['value'] as String, definition.dataType) as T,
    );
  }

  ///Factory constructor for user setting(assuming you fetch definition separately)
  factory Setting.fromGlobalMap(
    Map<String, dynamic> map,
    SettingDefinition definition,
  ) {
    return Setting<T>(
      definition: definition,
      value: _parseValue(map['value'] as String, definition.dataType) as T,
    );
  }
}
