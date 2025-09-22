import 'package:ai_chat/core/services/hive_service.dart';
import 'package:hive/hive.dart';

import '../domain/ai_chat_model.dart';

/// A repository for managing aiChat-related operation using hive
class AiChatRepository {
  /// The hive box contains [AiChatModel] instances.
  Box<AiChatModel> get _box => Hive.box<AiChatModel>(HiveService.aiChatBoxName);

  /// Retrieves all aiChat from the local Hive storages.
  ///
  /// Returns a [List] of [AiChatModel] instances
  Future<List<AiChatModel>> getAiChat() async {
    return _box.values.toList();
  }

  /// Creates and saves a new [AiChatModel] using the provided [usersText]
  Future<AiChatModel?> addAiChat(String usersText) async {
    final key = DateTime.now().millisecondsSinceEpoch.toString();
    final aiChat = AiChatModel(
      id: key,
      chatTextBody: usersText,
      sentTime: DateTime.now().toIso8601String(),
      isSeen: false,
      isReplied: false,
      replyText: '',
    );
    await _box.put(key, aiChat);
    return aiChat;
  }

  /// Update an existing chat in the database, identified by [id], with the new [chat] data
  Future<void> updateAiChat(String id, AiChatModel chat) async {
    await _box.put(id, chat);
  }
}
