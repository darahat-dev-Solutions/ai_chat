import 'package:ai_chat/core/api/api_service.dart';
import 'package:ai_chat/features/ai_chat/domain/ai_module.dart';
import 'package:dio/dio.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ApiService)
class ApiServiceImpl implements ApiService {
  final Dio _dio;

  // Base URL is now configured here
  // ApiServiceImpl(this._dio) {
  //   _dio.options.baseUrl = dotenv.env['BASE_API_URL']!;
  // }
  ApiServiceImpl(this._dio);
  @override
  Future<List<AiChatModule>> getAiChatModules() async {
    try {
      final response = await _dio.get('/ai-modules');
      final modules = (response.data as List)
          .map((item) => AiChatModule.fromJson(item))
          .toList();
      return modules;
    } on DioException catch (e, s) {
      throw Exception(
          'Failed to load AI chat modules. DioException: type=${e.type}, message=${e.message}, error=${e.error}, stackTrace=$s');
    } catch (e, s) {
      throw Exception('Failed to load AI Chat Modules. Error: $e, stackTrace: $s');
    }
  }

  @override
  Future<AiChatModuleDetails> getAiChatModuleDetails(int id) async {
    try {
      final response = await _dio.get('/ai-modules/$id');
      return AiChatModuleDetails.fromJson(response.data);
    } on DioException catch (e, s) {
      throw Exception(
          'Failed to load module details for $id. DioException: type=${e.type}, message=${e.message}, error=${e.error}, stackTrace=$s');
    } catch (e, s) {
      throw Exception(
          'Failed to load module details for id: $id. Error: $e, stackTrace: $s');
    }
  }
}
