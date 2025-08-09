import 'package:hive/hive.dart';

part 'ai_chat_model.g.dart';

@HiveType(typeId: 4)
/// its User model for authentication
class AiChatModel {
  /// first field for the hive/table is id
  @HiveField(0)
  final String? id;

  /// Chat Body
  @HiveField(1)
  final String? chatTextBody;

  /// when the message sent
  @HiveField(2)
  final String sentTime;

  /// is user/Ai checked
  @HiveField(3)
  final bool? isSeen;

  /// is user/ai replied
  @HiveField(4)
  final bool? isReplied;

  /// is user/ai replied
  @HiveField(5)
  final String? replyText;

  /// its construct of UserModel class . its for call UserModel to other dart file.  this.name is not required
  AiChatModel({
    this.id,
    this.chatTextBody,
    required this.sentTime,
    this.isSeen,
    this.isReplied,
    this.replyText,
  });

  ///creating a copy of an existing object with some updated fields and the actual object remain unchanged
  ///its used when need to update any field .
  ///used riverpod to state management.
  AiChatModel copyWith({
    String? id,
    String? chatTextBody,
    String? sentTime,
    bool? isSeen,
    bool? isReplied,
    String? replyText,
  }) {
    return AiChatModel(
      id: id ?? this.id,
      chatTextBody: chatTextBody ?? this.chatTextBody,
      sentTime: sentTime ?? this.sentTime,
      isSeen: isSeen ?? this.isSeen,
      isReplied: isReplied ?? this.isReplied,
      replyText: replyText ?? this.replyText,
    );
  }
}

///making an extension instead of calling getAiChat() everytime to load all aiChats
extension AiChatListUtils on List<AiChatModel> {
  /// Returns a aiChat by its ID and applies the update.
  List<AiChatModel> updated(String tid, AiChatModel updatedChat) {
    return [
      for (final chat in this)
        if (chat.id == tid)
          /// When we find the aiChat, create a new one with the updated title
          updatedChat
        else
          /// Otherwise, keep the existing aiChat
          chat,
    ];
  }
}
