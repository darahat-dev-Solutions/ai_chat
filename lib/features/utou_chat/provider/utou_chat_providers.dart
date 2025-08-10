import 'package:ai_chat/core/services/mistral_service.dart';
import 'package:ai_chat/core/services/voice_to_text_service.dart';
import 'package:ai_chat/features/utou_chat/application/utou_chat_controller.dart';
import 'package:ai_chat/features/utou_chat/domain/utou_chat_model.dart';
import 'package:ai_chat/features/utou_chat/infrastructure/utou_chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// UToUChat repository that interacts with Hive
final uToUChatRepositoryProvider = Provider<UToUChatRepository>(
  (ref) => UToUChatRepository(),
);

/// Voice input for adding uToUChat
final voiceToTextProvider = Provider<VoiceToTextService>((ref) {
  return VoiceToTextService(ref);
});

/// Indicates whether voice is recording
final isListeningProvider = StateProvider<bool>((ref) => false);

/// to check The AISummary is expanded or not
final isExpandedSummaryProvider = StateProvider<bool>((ref) => false);

/// to check The Floating button is expanded or not
final isExpandedFabProvider = StateProvider<bool>((ref) => false);

/// Controller for uToUChat logic and Hive access
final uToUChatControllerProvider =
    StateNotifierProvider<UToUChatController, AsyncValue<List<UToUChatModel>>>((
      ref,
    ) {
      final repo = ref.watch(uToUChatRepositoryProvider);
      return UToUChatController(repo, ref);
    });

/// taking only those uToUChats which are incomplete
// final incompleteTasksProvider = Provider<AsyncValue<List<UToUChatModel>>>((ref) {
//   return ref.watch(uToUChatControllerProvider);
// });

/// Mistral AI summary service
final mistralServiceProvider = Provider((ref) => MistralService());

/// Async summary from Mistral for uToUChat list
/// Async summary from Mistral for incomplete uToUChats
final uToUSummaryProvider = FutureProvider<String>((ref) async {
  final uToUChatAsync = ref.watch(uToUChatControllerProvider);
  return uToUChatAsync.when(
    data: (uToUChats) {
      if (uToUChats.isEmpty) {
        return "No Chat to answer";
      }
      final uToUFeed = uToUChats
          .map(
            (t) =>
                'just give answer very shortly.Like as human chat. the text is- ${t.chatTextBody}',
          )
          .join('\n');
      final service = ref.read(mistralServiceProvider);
      return service.generateSummary(uToUFeed);
    },
    error: (_, __) => "Could not generate answer due to an error",
    loading: () => "Generating answer....",
  );
});
