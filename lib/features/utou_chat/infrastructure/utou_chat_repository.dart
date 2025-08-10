import 'package:ai_chat/core/services/hive_service.dart';
import 'package:ai_chat/features/utou_chat/domain/utou_chat_model.dart';
import 'package:hive/hive.dart';

/// A repository class for managing uToUChat-related operation using hive
class UToUChatRepository {
  /// The hive box containing [UToUChatModel] instances.

  Box<UToUChatModel> get _box => HiveService.uTouChatBoxInit;

  /// Retrives all uToUChat from the local Hive storages.
  ///
  /// Returns a [List] of [UToUChatModel] instances
  Future<List<UToUChatModel>> getUtoUChat() async {
    return _box.values.toList();
  }

  /// Adds a new uToUChat with the given [text] as the title.
  Future<UToUChatModel?> addUtoUChat(String usersText) async {
    final key = DateTime.now().millisecondsSinceEpoch.toString();
    final uToUChat = UToUChatModel(
      id: key,
      chatTextBody: usersText,
      sentTime: DateTime.now().toIso8601String(),
      isRead: false,
      isDelivered: false,
      senderId: '',
      receiverId: '',
    );
    await _box.put(key, uToUChat);
    return uToUChat;
  }

  /// Toggles the completion status of a isSeen identified by [id]
  ///
  /// if the uToUChat exists, it will be updated with the opposite 'isCompleted' value.
  Future<void> toggleIsReadChat(String id) async {
    final uToUChat = _box.get(id);
    if (uToUChat != null) {
      final updated = uToUChat.copyWith(isRead: !(uToUChat.isRead ?? false));
      await _box.put(id, updated);
    }
  }

  /// Toggle/Update value of isReplied
  Future<void> toggleIsDeliveredChat(String id) async {
    final uToUChat = _box.get(id);
    if (uToUChat != null) {
      final updated = uToUChat.copyWith(
        isDelivered: !(uToUChat.isDelivered ?? false),
      );
      await _box.put(id, updated);
    }
  }

  /// Removes the chat identified by [tid] from local storage
  Future<void> removeChat(String id) async {
    await _box.delete(id);
  }

  /// Updates the title of the uToUChat identified by [id] with [chatTextBody]
  Future<void> editUserChat(String id, String newChatTextBody) async {
    final uToUChat = _box.get(id);
    if (uToUChat != null) {
      final updated = uToUChat.copyWith(chatTextBody: newChatTextBody);
      await _box.put(id, updated);
    }
  }

  /// Update an existing chat in the database
  Future<void> updateUToUChat(String id, UToUChatModel chat) async {
    await _box.put(id, chat);
  }
}
