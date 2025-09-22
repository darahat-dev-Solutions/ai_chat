import 'package:ai_chat/core/utils/logger.dart';
import 'package:ai_chat/features/utou_chat/domain/utou_chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';

/// A repository class for managing uToUChat-related operation using hive
class UToUChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Connect with other provider
  // final Ref ref; // Add Ref object
  ///Get Logger functions
  final AppLogger appLogger;

  /// User to user modal box instance
  final Box<UToUChatModel> uTouBox;

  /// The hive box containing [UToUChatModel] instances.
  UToUChatRepository(this.appLogger, this.uTouBox);
  // Box<UToUChatModel> get _box => HiveService.uTouChatBoxInit;

  /// get Chat Room ID
  String getChatRoomId(String? userId1, String userId2) {
    if (userId1.hashCode <= userId2.hashCode) {
      return '$userId1-$userId2';
    } else {
      return '$userId2-$userId1';
    }
  }

  /// SendMessage function to send message to specific Chat room
  Future<void> sendMessage(UToUChatModel chat) async {
    final chatRoomId = getChatRoomId(chat.senderId!, chat.receiverId!);
    final messageRef = _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .doc(chat.id);
    try {
      await messageRef.set(chat.toJson());
      await uTouBox.put(chat.id, chat);
    } catch (e, s) {
      appLogger.debug(
        'I am from uTou_chat_repository.dart. Error: $e and state is $s',
      );
    }
  }

  /// Get Online messages from firestore
  Stream<List<UToUChatModel>> getMessages(
    String? currentUserId,
    String otherUserId,
  ) {
    final chatRoomId = getChatRoomId(currentUserId ?? '', otherUserId);
    try {
      return _firestore
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('sentTime', descending: false)
          .snapshots()
          .map((snapshot) {
        final messages = snapshot.docs.map((doc) {
          final message = UToUChatModel.fromJson(doc.data());
          uTouBox.put(message.id, message);
          return message;
        }).toList();
        return messages;
      });
    } catch (e, s) {
      appLogger.debug(
        'I am from uTou_chat_repository.dart. getMessages Error: $e and state is $s',
      );
      // Throw to satisfy the non-nullable return type
      throw Exception('Failed to get messages: $e');
    }
  }

  /// get offline uToUChat from the local Hive storages.
  ///
  /// Returns a [List] of [UToUChatModel] instances
  Future<List<UToUChatModel>> getOfflineUtoUMessages(
    String currentUserId,
    String otherUserId,
  ) async {
    final allMessages = uTouBox.values.toList();
    return allMessages
        .where(
          (message) =>
              (message.senderId == currentUserId &&
                  message.receiverId == otherUserId) ||
              (message.senderId == otherUserId &&
                  message.receiverId == current),
        )
        .toList();
  }

  /// Adds a new uToUChat with the given [text] as the title.
  Future<UToUChatModel?> addOfflineUtoUChat(UToUChatModel message) async {
    await uTouBox.put(message.id, message);
    return message;
  }

  /// Toggles the completion status of a isSeen identified by [id]
  ///
  /// if the uToUChat exists, it will be updated with the opposite 'isCompleted' value.
  Future<void> toggleIsReadChat(
    String id,
    String receiverId,
    String senderId,
  ) async {
    final uToUChat = uTouBox.get(id);
    if (uToUChat != null) {
      final updated = uToUChat.copyWith(isRead: !(uToUChat.isRead ?? false));
      await uTouBox.put(id, updated);
      await updateMessageReadStatus(id, receiverId, senderId);
    }
  }

  /// Update message read status in Firestore
  Future<void> updateMessageReadStatus(
    String messageId,
    String receiverId,
    String senderId,
  ) async {
    final chatRoomId = getChatRoomId(receiverId, senderId);
    final messageRef = _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId);
    await messageRef.update({'isRead': true});
  }

  /// Toggle/Update value of isReplied
  Future<void> toggleIsDeliveredChat(String id) async {
    final uToUChat = uTouBox.get(id);
    if (uToUChat != null) {
      final updated = uToUChat.copyWith(
        isDelivered: !(uToUChat.isDelivered ?? false),
      );
      await uTouBox.put(id, updated);
    }
  }
}
