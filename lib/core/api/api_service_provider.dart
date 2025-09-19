import 'package:ai_chat/core/api/api_service.dart';
import 'package:ai_chat/core/api/dio_provider.dart';
import 'package:ai_chat/core/services/api_service_implementation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the concrete implementation of [ApiService]
///
/// This provider is responsible for creating an instance of [ApiServiceImpl]
final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiServiceImpl(dio);
});
