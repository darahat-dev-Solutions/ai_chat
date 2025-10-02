import 'package:ai_chat/features/ai_chat/domain/ai_chat_module.dart';
import 'package:ai_chat/features/ai_chat/domain/item.dart';

/// Provides API Functions Names
abstract class ApiService {
  /// Get All AI Chat Module
  Future<List<AiChatModule>> getAiChatModules();

  /// Get product popular items
  Future<List<Item>> getPopularItems();
}
