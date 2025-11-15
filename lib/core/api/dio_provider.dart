import 'package:ai_chat/core/config/env_validator.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Instance of [dioProvider] (Set UP DIO)
/// Note: This provider should only be accessed after env validation passes in main.dart
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  /// baseUrl - using the new validator
  final baseUrl = EnvValidator.getEnv('BASE_API_URL');

  /// Checking Is base URL exist - detailed error message
  if (baseUrl == null || baseUrl.isEmpty) {
    throw Exception(
      'BASE_API_URL is not configured in .env file. '
      'Please copy .env.example to .env and fill in your backend API URL. '
      'See README.md for setup instructions.',
    );
  }

  /// Set required parameters to dio
  dio.options.baseUrl = baseUrl;
  dio.options.connectTimeout = const Duration(seconds: 5);
  dio.options.receiveTimeout = const Duration(seconds: 3);
  return dio;
});
