import 'package:hive/hive.dart';

part 'ai_chat_model.g.dart';

@HiveType(typeId: 4)

/// Represents the AI Chat
class AiChatModel {
  /// Chat ID
  @HiveField(0)
  final String? id;

  /// Chat Text
  @HiveField(1)
  final String? chatTextBody;

  /// Sent Time
  @HiveField(2)
  final String sentTime;

  /// Seen Time
  @HiveField(3)
  final bool? isSeen;

  /// Reply Time
  @HiveField(4)
  final bool? isReplied;

  /// Reply Text
  @HiveField(5)
  final String? replyText;

  /// Constructor of [AiChatModel]
  AiChatModel({
    this.id,
    this.chatTextBody,
    required this.sentTime,
    this.isSeen,
    this.isReplied,
    this.replyText,
  });

  /// Creates a new  [AiChatModel] instance
  ///
  /// This is useful for creating a modified copy of the state without
  /// Mutating the Original object. Which is the best practice for State management
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
