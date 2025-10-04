import 'package:ai_chat/core/api/api_service_provider.dart';
import 'package:ai_chat/core/services/custom_llm_service.dart';
import 'package:ai_chat/core/services/voice_to_text_service.dart';
import 'package:ai_chat/features/ai_chat/domain/ai_chat_module.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/ai_chat_controller.dart';
import '../domain/ai_chat_model.dart';
import '../infrastructure/ai_chat_repository.dart';

///----- START: New Provider ---
/// Provides and caches the list of all AI Chat Modules (prompts) from the API
final aiChatModulesProvider = FutureProvider<List<AiChatModule>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getAiChatModules();
});

/// Provides the [AiChatRepository] that interacts with Hive
final aiChatRepositoryProvider = Provider<AiChatRepository>(
  (ref) => AiChatRepository(),
);

/// Provides the [VoiceToTextService] for speech-to-text conversion
final voiceToTextProvider = Provider<VoiceToTextService>((ref) {
  return VoiceToTextService(ref);
});

/// Indicates whether voice is recording
final isListeningProvider = StateProvider<bool>((ref) => false);

/// Whether The AISummary is expanded or not
final isExpandedSummaryProvider = StateProvider<bool>((ref) => false);

/// Whether The Floating button is expanded or not
final isExpandedFabProvider = StateProvider<bool>((ref) => false);

/// Provides the [AiChatController] which manages the state of the chat list
final aiChatControllerProvider =
    AsyncNotifierProvider<AiChatController, List<AiChatModel>>(
  () => AiChatController(),
);

/// Provides the [CustomLlmService] that interacts with LLM
final customLlmServiceProvider = Provider((ref) => CustomLlmService());

/// Async summary from LLM for aiChat list
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
