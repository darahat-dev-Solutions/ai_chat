import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Instance of [dioProvider] (Set UP DIO)
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  /// baseUrl
  final baseUrl = dotenv.env['BASE_API_URL'];

  /// Checking Is base URL exist
  if (baseUrl == null || baseUrl.isEmpty) {
    throw Exception('BASE_API_URL is not set or is empty in .env file');
  }

  /// Set required parameters to dio
  dio.options.baseUrl = baseUrl;
  dio.options.connectTimeout = const Duration(seconds: 5);
  dio.options.receiveTimeout = const Duration(seconds: 3);
  return dio;
});
