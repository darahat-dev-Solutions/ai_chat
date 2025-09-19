import 'package:ai_chat/core/api/api_service.dart';
import 'package:ai_chat/core/services/api_service_implementation.dart';
import 'package:ai_chat/features/ai_chat/domain/ai_chat_module.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiService', () {
    late ApiService apiService;
    setUpAll(() async {
      // Load environment variables from .env file
      await dotenv.load(fileName: ".env");
      // Create a Dio instance
      final dio = Dio();
      // Create an ApiService instance
      apiService = ApiServiceImpl(dio);
    });

    test('GetAiChatModules returns a list of modules', () async {
      try {
        final modules = await apiService.getAiChatModules();
        expect(modules, isA<List<AiChatModule>>());
        expect(modules.isNotEmpty, isTrue);
        print('Fetched modules:');
        for (var module in modules) {
          print(' -  ID: ${module.id}, Name: ${module.name}');
        }
      } catch (e) {
        fail('Failed to get AI chat modules: $e');
      }
    });

    test('getAiChatModuleDetails returns module details', () async {
      try {
        /// Assuming a module with ID 1 exists
        const moduleId = 1;
        final details = await apiService.getAiChatModuleDetails(moduleId);
        expect(details, isA<AiChatModuleDetails>());
        expect(details.id, moduleId);
        print('Fetched module details for ID $moduleId:');
        print(' - ID: ${details.id}');
        print(' - Name: ${details.name}');
        print(' - Description:${details.description}');
        print(' - Prompt: ${details.prompt}');
        print(' - Created At: ${details.createdAt}');
        print(' - Updated At:${details.updatedAt}');
      } catch (e) {
        fail('Failed to get AI chat module details: $e');
      }
    });
  });
}
