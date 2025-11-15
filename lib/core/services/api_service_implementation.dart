import 'package:ai_chat/core/api/api_service.dart';
import 'package:ai_chat/core/utils/logger.dart';
import 'package:ai_chat/features/ai_chat/domain/ai_chat_module.dart';
import 'package:ai_chat/features/ai_chat/domain/item.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ApiService)

/// Providing API Functions
class ApiServiceImpl implements ApiService {
  /// To get HTTP Access
  final Dio _dio;

  /// count getAiChatModules call amount(Only For Debug)
  int _modulesCallCount = 0;

  /// count getAiChatModuleDetails call amount(Only For Debug)
  int _moduleDetailsCallCount = 0;

  /// To Get Logger Functions
  AppLogger appLogger = AppLogger();

  // Base URL is now configured here
  // ApiServiceImpl(this._dio) {
  //   _dio.options.baseUrl = dotenv.env['BASE_API_URL']!;
  // }
  ApiServiceImpl(this._dio);
  @override
  Future<List<AiChatModule>> getAiChatModules() async {
    _modulesCallCount++; // increase counter
    // appLogger.error('getAiChatModules called $_modulesCallCount times');
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
      throw Exception(
          'Failed to load AI Chat Modules. Error: $e, stackTrace: $s');
    }
  }

  Future<List<Item>> getPopularItems() async {
    print('🚀 DEBUG: getPopularItems API called!');

    try {
      final response = await _dio.get('/coffee-shop/popular-items');
      print('🚀 DEBUG: Response status: ${response.statusCode}');
      print('🚀 DEBUG: Response data: ${response.data}');
      if (response.statusCode == 200 && response.data != null) {
        // Normalize incoming JSON to ensure numeric fields have proper types
        final rawList = response.data['data'] as List;
        final normalized = rawList.map((rawItem) {
          // Ensure we have a mutable Map<String, dynamic>
          final Map<String, dynamic> itemMap =
              Map<String, dynamic>.from(rawItem as Map);

          // Normalize item_id (could come as String)
          final idVal = itemMap['item_id'] ?? itemMap['id'];
          if (idVal != null && idVal is String) {
            final parsed = int.tryParse(idVal);
            if (parsed != null) {
              itemMap['item_id'] = parsed;
            }
          }

          // Normalize price (could come as String or int)
          final priceVal = itemMap['price'];
          if (priceVal != null) {
            if (priceVal is String) {
              // remove common formatting like commas or currency symbols
              final cleaned = priceVal.replaceAll(RegExp(r"[^0-9.\-]"), '');
              final parsed = double.tryParse(cleaned);
              if (parsed != null) {
                itemMap['price'] = parsed;
              }
            } else if (priceVal is int) {
              itemMap['price'] = priceVal.toDouble();
            }
          }

          return itemMap;
        }).toList();

        final items = normalized.map((item) => Item.fromJson(item)).toList();
        return items;
      } else {
        appLogger
            .warning('Failed to load popular items: ${response.statusCode}');
        throw Exception(
            'Failed to load popular items: HTTP ${response.statusCode}');
      }
    } on DioException catch (e, s) {
      appLogger.error('DioException in getPopularItems: $e');
      throw Exception(
          'Failed to load popular items. DioException: type=${e.type}, message=${e.message}, error=${e.error}, stackTrace=$s');
    } catch (e, s) {
      appLogger.error('Error in getPopularItems: $e');
      throw Exception(
          'Failed to load Popular items. Error: $e, stackTrace: $s');
    }
  }
}
