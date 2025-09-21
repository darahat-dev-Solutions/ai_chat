import 'package:ai_chat/core/services/custom_llm_service.dart';
import 'package:ai_chat/core/services/voice_to_text_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/ai_chat_controller.dart';
import '../domain/ai_chat_model.dart';
import '../infrastructure/ai_chat_repository.dart';

/// AiChat repository that interacts with Hive
final aiChatRepositoryProvider = Provider<AiChatRepository>(
  (ref) => AiChatRepository(),
);

/// Voice input for adding aiChat
final voiceToTextProvider = Provider<VoiceToTextService>((ref) {
  return VoiceToTextService(ref);
});

/// Indicates whether voice is recording
final isListeningProvider = StateProvider<bool>((ref) => false);

/// to check The AISummary is expanded or not
final isExpandedSummaryProvider = StateProvider<bool>((ref) => false);

/// to check The Floating button is expanded or not
final isExpandedFabProvider = StateProvider<bool>((ref) => false);

/// Controller for aiChat logic and Hive access
final aiChatControllerProvider =
    AsyncNotifierProvider<AiChatController, List<AiChatModel>>(
  () => AiChatController(),
);

/// Custom LLM summary service
final customLlmServiceProvider = Provider((ref) => CustomLlmService());

/// Async summary from LLM for aiChat list
/// Async summary from LLM for incomplete aiChats
final aiSummaryProvider = FutureProvider<String>((ref) async {
  final aiChatAsync = ref.watch(aiChatControllerProvider);
  return aiChatAsync.when(
    data: (aiChats) {
      if (aiChats.isEmpty) {
        return "No Chat to answer";
      }
      final aiFeed = aiChats
          .map(
            (t) =>
                'just give answer very shortly.Like as human chat. the text is- ${t.chatTextBody}',
          )
          .join('\n');
      final service = ref.read(customLlmServiceProvider);
      return service.generateSummary(aiFeed);
    },
    error: (_, __) => "Could not generate answer due to an error",
    loading: () => "Generating answer....",
  );
});
