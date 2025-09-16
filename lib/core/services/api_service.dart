import 'package:ai_chat/features/ai_chat/domain/ai_module.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

abstract class ApiService {
  Future<List<AiChatModule>> getAiChatModules();
  Future<AiChatModuleDetails> getAiChatModuleDetails(int id);
}

@LazySingleton(as: ApiService)
class ApiServiceImpl implements ApiService {
  final Dio _dio;

  // Base URL is now configured here
  ApiServiceImpl(this._dio) {
    _dio.options.baseUrl = dotenv.env['BASE_API_URL']!;
  }

  @override
  Future<List<AiChatModule>> getAiChatModules() async {
    try {
      final response = await _dio.get('/ai-module');
      final modules = (response.data as List)
          .map((item) => AiChatModule.fromJson(item))
          .toList();
      return modules;
    } catch (e) {
      throw Exception('Failed to load AI Chat Modules');
    }
  }

  @override
  Future<AiChatModuleDetails> getAiChatModuleDetails(int id) async {
    try {
      final response = await _dio.get('/ai-module/$id');
      return AiChatModuleDetails.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load module details for id: $id');
    }
  }
}
