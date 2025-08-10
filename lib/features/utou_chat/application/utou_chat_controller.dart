import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_chat/features/utou_chat/domain/utou_chat_model.dart';
import '../infrastructure/utou_chat_repository.dart';

/// Used to indicate loading status in the UI
final uToUChatLoadingProvider = StateProvider<bool>((ref) => false);

/// Main UToU Chat Controller connected to Hive-backed UToUChatRepository
class UToUChatController
    extends StateNotifier<AsyncValue<List<UToUChatModel>>> {
  final UToUChatRepository _repo;

  /// ref is a riverpod object which used by providers to interact with other providers and life cycle
  /// of the application
  /// example ref.read, ref.write etc
  final Ref ref;

  /// UToUChatController Constructor to call it from outside
  UToUChatController(this._repo, this.ref) : super(const AsyncValue.loading()) {
    loadUToUChat();
  }

  /// Load all uToUChats from repository and update the state
  Future<void> loadUToUChat() async {
    state = const AsyncValue.loading();
    try {
      final uToUChats = await _repo.getUtoUChat();

      /// Filter for incomplete uToUChats and set the data state
      state = AsyncValue.data(uToUChats);
    } catch (e, s) {
      /// If loading fails, set the error state
      state = AsyncValue.error(e, s);
    }
  }

  /// Load all uToUChats from repository
  // Future<void> getUToUChats() async {
  //   ref.read(uToUChatLoadingProvider.notifier).state = true;

  //   final uToUChats = await _repo.uToUChats();
  //   state = uToUChats.where((uToUChat) => uToUChat.isCompleted == false).toList();

  //   ref.read(uToUChatLoadingProvider.notifier).state = false;
  // }

  /// Add a new uToUChat and reload list
  Future<void> addUToUChat(
    String usersText,
    String systemPrompt,
    String userPromptPrefix,
    String systemQuickReplyPrompt,
    String errorMistralRequest,
  ) async {
    /// Get The current list of uToUChats from the state's value
    final currentUToUChats = state.value ?? [];
    final usersMessage = await _repo.addUtoUChat(usersText);
    if (usersMessage == null) return;

    state = AsyncValue.data([...currentUToUChats, usersMessage]);
    // try {
    //   /// Get AI Reply
    //   final mistralService = ref.read(mistralServiceProvider);
    //   final uToUReplyText = await mistralService.generateQuickReply(
    //     usersText,
    //     systemPrompt,
    //     userPromptPrefix,
    //     systemQuickReplyPrompt,
    //     errorMistralRequest,
    //   );

    //   /// Update the message with AI's reply
    //   final updatedMessage = usersMessage.copyWith(
    //     replyText: uToUReplyText,
    //     isDelivered: true,
    //     isRead: true,

    //     /// mark as Seen by AI
    //   );
    //   await _repo.updateUToUChat(usersMessage.id!, updatedMessage);
    //   state = AsyncValue.data(
    //     state.value!.updated(usersMessage.id!, updatedMessage),
    //   );
    // } catch (e, s) {
    //   throw ServerException(
    //     '🚀 ~Save on hive of mistral reply from (ai_chat_controller.dart) $e and this is $s',
    //   );
    // }
    // finally {
    //   final updatedMessage = usersMessage.copyWith(
    //     replyText: "Sorry, I couldn't get a response",
    //     isReplied: true,
    //   );
    //   await _repo.updateUToUChat(usersMessage.id!, updatedMessage);
    //   state = AsyncValue.data(
    //     state.value!.updated(usersMessage.id!, updatedMessage),
    //   );
    // }
  }

  /// Toggle a uToUChat and reload list
  Future<void> toggleIsReadChat(String id) async {
    final currentChats = state.value ?? [];
    if (currentChats.isEmpty) return;
    await _repo.toggleIsReadChat(id);

    // final chatToUpdate = currentChats.firstWhere((t) => t.id == id);

    /// changing uToUChat according to which tid is toggled check and updated using copy with
    /// which generates copy of that exact object which is toggled
    ///
    final updatedList =
        currentChats.map((chat) {
          if (chat.id == id) {
            return chat.copyWith(isRead: !(chat.isRead ?? false));
          }
          return chat;
        }).toList();

    /// Update the state with the new list
    state = AsyncValue.data(updatedList);
  }

  /// Update chat status value of is it replied
  Future<void> toggleIsRepliedChat(String id) async {
    final currentChats = state.value ?? [];
    if (currentChats.isEmpty) return;

    await _repo.toggleIsDeliveredChat(id);
    final chatToUpdate = currentChats.firstWhere((chat) => chat.id == id);
    final updatedList = currentChats.updated(
      id,
      chatToUpdate.copyWith(isDelivered: !(chatToUpdate.isDelivered ?? false)),
    );
    state = AsyncValue.data(updatedList);
  }

  /// Remove a uToUChat and reload list
  Future<void> removeUToUChat(String id) async {
    final currentUToUChats = state.value ?? [];

    await _repo.removeChat(id);
    state = AsyncValue.data(
      currentUToUChats.where((chat) => chat.id != id).toList(),
    );
  }

  /// Edit a uToUChat and reload list
  Future<void> editUToUChat(String id, String newText) async {
    final currentUToUChats = state.value ?? [];
    if (currentUToUChats.isEmpty) return;
    await _repo.editUserChat(id, newText);
    final uToUChatToUpdate = currentUToUChats.firstWhere((t) => t.id == id);

    /// changing aiChat according to which tid is toggled check and updated using copy with
    /// which generates copy of that exact object which is toggled
    final updatedList = currentUToUChats.updated(
      id,
      uToUChatToUpdate.copyWith(chatTextBody: newText),
    );

    /// Update the state with the new list
    state = AsyncValue.data(updatedList);
  }
}
