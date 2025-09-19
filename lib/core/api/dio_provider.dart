import 'package:ai_chat/core/api/api_service.dart';
import 'package:ai_chat/core/services/api_service_implementation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Instance of dioProvider
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  /// You can add base URL and other configurations here.
  /// for Example:
  final baseUrl = dotenv.env['BASE_API_URL'];
  if (baseUrl == null || baseUrl.isEmpty) {
    throw Exception('BASE_API_URL is not set or is empty in .env file');
  }
  dio.options.baseUrl = baseUrl;
  dio.options.connectTimeout = const Duration(seconds: 5);
  dio.options.receiveTimeout = const Duration(seconds: 3);
  return dio;
});

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiServiceImpl(dio);
});
