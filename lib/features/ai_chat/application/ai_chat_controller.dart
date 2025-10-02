import 'package:ai_chat/core/errors/exceptions.dart';
import 'package:ai_chat/core/utils/ai_chat_list_utils.dart';
import 'package:ai_chat/features/ai_chat/domain/item.dart';
import 'package:ai_chat/features/ai_chat/provider/ai_chat_providers.dart';
import 'package:ai_chat/features/ai_chat/provider/popular_items_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/ai_chat_model.dart';

/// A Controller class which manages User to AI Chat
class AiChatController extends AsyncNotifier<List<AiChatModel>> {
  /// The `build` method is called once when the notifier is first created
  /// It should return a Future that resolves to the initial state.
  @override
  Future<List<AiChatModel>> build() async {
    final repo = ref.watch(aiChatRepositoryProvider);
    return repo.getAiChat();
  }

  /// Add a new aiChat and reload list
  Future<void> addAiChat(
    String usersText,
    String systemPrompt,
    String userPromptPrefix,
    String errorCustomLlmRequest,
  ) async {
    /// Retrieves the [repo] instance from its provider
    final repo = ref.read(aiChatRepositoryProvider);

    /// Current list of Persist state's chat
    final currentAiChats = state.value ?? [];

    /// Add new user Text
    final usersMessage = await repo.addAiChat(usersText);

    /// If user message is null return nothing
    if (usersMessage == null) return;

    /// Persist the value of [userMessage] to [currentAiChats] local state array .
    state = AsyncValue.data([...currentAiChats, usersMessage]);

    try {
      /// Retrieves the [CustomLlmService] instance from its provider
      final customLlmService = ref.read(customLlmServiceProvider);

      /// Read the popular items provider to get the list of items
      final popularItemsAsyncValue = ref.read(popularItemsProvider);

      /// Safely extract the list of items from the AsyncValue.
      /// If the items are loading or there's an error , default to an empty list
      final popularItems = popularItemsAsyncValue.when(
          data: (items) => items,
          error: (error, stackTrace) => <Item>[],
          loading: () => <Item>[]);

      /// Passes Required parameters and Get AI Reply you
      final aiReplyText = await customLlmService.generateQuickReply(usersText,
          systemPrompt, userPromptPrefix, errorCustomLlmRequest, popularItems);

      /// Creates a new [usersMessage] instance with updated values
      ///
      /// This is useful for creating a modified copy of the state without
      /// Mutating the original object, which is a best practice for state management.
      final updatedMessage = usersMessage.copyWith(
        replyText: aiReplyText,
        isReplied: true,
        isSeen: true,
      );

      /// Update Message according to Local DB
      await repo.updateAiChat(usersMessage.id!, updatedMessage);

      /// Persist State
      state = AsyncValue.data(
        state.value!.updated(usersMessage.id!, updatedMessage),
      );
    } catch (e, s) {
      throw ServerException(
        '🚀 ~Save on hive of LLM reply from (ai_chat_controller.dart) $e and this is $s',
      );
    }
  }
}
