import 'package:ai_chat/features/ai_chat/domain/ai_chat_model.dart';
import 'package:flutter/foundation.dart';

/// Represents the state of the AI chat feature.
///
/// This class is immutable. To update the state, create a new instance
/// using the [copyWith] method
class AiChatState {
  /// The List of chat messages
  final List<AiChatModel> chats;

  /// Creates an instance of the AI chat state, with an optional
  /// list of chats
  const AiChatState({
    this.chats = const [],
  });

  /// Creates a new [AiChatState] instance with updated values
  ///
  /// This is useful for creating a modified copy of the state
  /// without mutating the original object, which is a best practice for state management
  AiChatState copyWith({
    List<AiChatModel>? chats,
  }) {
    return AiChatState(
      chats: chats ?? this.chats,
    );
  }

  /// Compares this [AiChatState] to another object for equality
  ///
  /// Returns true if the objects are the same instance or if their
  /// properties are equal
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is AiChatState && listEquals(other.chats, chats);
  }

  /// Generates a hash code for this [AiChatState] object
  ///
  /// This is used by hash-based collections like [HashSet] and [HashMap]
  /// and should be consistent with the [==] operator
  @override
  int get hashCode => chats.hashCode;
}
