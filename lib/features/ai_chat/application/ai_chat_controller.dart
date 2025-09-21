import 'package:ai_chat/core/errors/exceptions.dart';
import 'package:ai_chat/core/utils/ai_chat_list_utils.dart';
import 'package:ai_chat/features/ai_chat/provider/ai_chat_providers.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/ai_chat_model.dart';

/// Main Ai Chat Controller connected to Hive-backed AiChatRepository
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
    final repo = ref.read(aiChatRepositoryProvider);

    /// Get The current list of aiChats from the state's value
    final currentAiChats = state.value ?? [];
    final usersMessage = await repo.addAiChat(usersText);
    if (usersMessage == null) return;

    state = AsyncValue.data([...currentAiChats, usersMessage]);
    if (dotenv.env['USE_FIREBASE_EMULATOR'] == 'true') {
      ///In emulator mode, dont call the AI
      return;
    }
    try {
      /// Get AI Reply
      final customLlmService = ref.read(customLlmServiceProvider);
      final aiReplyText = await customLlmService.generateQuickReply(
        usersText,
        systemPrompt,
        userPromptPrefix,
        errorCustomLlmRequest,
      );

      /// Update the message with AI's reply
      final updatedMessage = usersMessage.copyWith(
        replyText: aiReplyText,
        isReplied: true,
        isSeen: true,
      );
      await repo.updateAiChat(usersMessage.id!, updatedMessage);
      state = AsyncValue.data(
        state.value!.updated(usersMessage.id!, updatedMessage),
      );
    } catch (e, s) {
      throw ServerException(
        '🚀 ~Save on hive of LLM reply from (ai_chat_controller.dart) $e and this is $s',
      );
    }
  }

  Future<void> toggleIsSeenChat(String id) async {
    final repo = ref.read(aiChatRepositoryProvider);

    final currentChats = state.value ?? [];
    if (currentChats.isEmpty) return;
    await repo.toggleIsSeenChat(id);

    // final chatToUpdate = currentChats.firstWhere((t) => t.id == id);

    /// changing aiChat according to which tid is toggled check and updated using copy with
    /// which generates copy of that exact object which is toggled
    ///
    final updatedList = currentChats.map((chat) {
      if (chat.id == id) {
        return chat.copyWith(isSeen: !(chat.isSeen ?? false));
      }
      return chat;
    }).toList();

    /// Update the state with the new list
    state = AsyncValue.data(updatedList);
  }

  /// Update chat status value of is it replied
  Future<void> toggleIsRepliedChat(String id) async {
    final repo = ref.read(aiChatRepositoryProvider);

    final currentChats = state.value ?? [];
    if (currentChats.isEmpty) return;

    await repo.toggleIsRepliedChat(id);
    final chatToUpdate = currentChats.firstWhere((chat) => chat.id == id);
    final updatedList = currentChats.updated(
      id,
      chatToUpdate.copyWith(isReplied: !(chatToUpdate.isReplied ?? false)),
    );
    state = AsyncValue.data(updatedList);
  }

  /// Remove a aiChat and reload list
  Future<void> removeAiChat(String id) async {
    final repo = ref.read(aiChatRepositoryProvider);

    final currentAiChats = state.value ?? [];

    await repo.removeChat(id);
    state = AsyncValue.data(
      currentAiChats.where((chat) => chat.id != id).toList(),
    );
  }

  /// Edit a aiChat and reload list
  Future<void> editAiChat(String id, String newText) async {
    final repo = ref.read(aiChatRepositoryProvider);

    final currentAiChats = state.value ?? [];
    if (currentAiChats.isEmpty) return;
    await repo.editUserChat(id, newText);
    final aiChatToUpdate = currentAiChats.firstWhere((t) => t.id == id);

    /// changing aiChat according to which tid is toggled check and updated using copy with
    /// which generates copy of that exact object which is toggled
    final updatedList = currentAiChats.updated(
      id,
      aiChatToUpdate.copyWith(chatTextBody: newText),
    );

    /// Update the state with the new list
    state = AsyncValue.data(updatedList);
  }
}
