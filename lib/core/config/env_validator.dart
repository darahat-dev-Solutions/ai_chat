import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment variable validation
class EnvValidator {
  /// List of required environment variables
  static const List<String> requiredEnvVars = [
    'BASE_API_URL',
    'AI_API_KEY',
    'FIREBASE_PROJECT_ID',
    'FIREBASE_API_KEY',
  ];

  /// Placeholder patterns to detect
  static const List<String> placeholderPatterns = [
    'YOUR ',
    'YOUR_',
    'PLACEHOLDER',
    'CHANGE_ME',
    'TODO',
    'EXAMPLE',
  ];

  /// Check if a value is a placeholder
  static bool _isPlaceholder(String value) {
    final lowerValue = value.toLowerCase();
    return placeholderPatterns
        .any((pattern) => lowerValue.contains(pattern.toLowerCase()));
  }

  /// Check if all required env variables are set
  static Map<String, String?> validateEnv() {
    final missingVars = <String, String?>{};

    for (final varName in requiredEnvVars) {
      final value = dotenv.env[varName];

      // Check if value is missing, empty, or is a placeholder
      if (value == null || value.isEmpty || _isPlaceholder(value)) {
        missingVars[varName] = value;
      }
    }

    return missingVars;
  }

  /// Get a specific env variable with fallback
  static String? getEnv(String key, {String? defaultValue}) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty || _isPlaceholder(value)) {
      return defaultValue;
    }
    return value;
  }

  /// Check if a single env variable exists and is valid
  static bool isEnvVarValid(String key) {
    final value = dotenv.env[key];
    return value != null && value.isNotEmpty && !_isPlaceholder(value);
  }
}
