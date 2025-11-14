import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/ai_chat_model.dart';

part 'ai_chat_state.freezed.dart';

@freezed
class AiChatState with _$AiChatState {
  const factory AiChatState({
    @Default([]) List<AiChatModel> chats,
  }) = _AiChatState;
}
