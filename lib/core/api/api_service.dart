import 'package:ai_chat/features/ai_chat/domain/ai_chat_module.dart';

/// Provides API Functions Names
abstract class ApiService {
  /// Get All AI Chat Module
  Future<List<AiChatModule>> getAiChatModules();

  /// Get A single detail AI Module
  Future<AiChatModuleDetails> getAiChatModuleDetails(int id);
}
