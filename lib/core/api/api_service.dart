import 'package:ai_chat/features/ai_chat/domain/ai_module.dart';

abstract class ApiService {
  Future<List<AiChatModule>> getAiChatModules();
  Future<AiChatModuleDetails> getAiChatModuleDetails(int id);
}
