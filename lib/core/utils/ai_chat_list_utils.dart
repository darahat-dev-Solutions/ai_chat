import 'package:ai_chat/features/ai_chat/domain/ai_chat_model.dart';

/// Grants new utility to any list of [AiChatModel]
extension AiChatListUtils on List<AiChatModel> {
  /// Creates a new list with a single chat updated
  ///
  /// This is an immutable operation. It returns a new list where the
  /// [AiChatModel] with an ID matching [tid] is replaced by [updatedChat]
  /// If No chat is found, it returns an identical copy of the original list
  List<AiChatModel> updated(String tid, AiChatModel updatedChat) {
    return map((messenger) => messenger.id == tid ? updatedChat : messenger)
        .toList();
  }
}
