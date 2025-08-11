import 'package:ai_chat/core/services/voice_to_text_service.dart';
import 'package:ai_chat/features/auth/domain/user_model.dart';
import 'package:ai_chat/features/auth/infrastructure/auth_repository.dart';
import 'package:ai_chat/features/auth/provider/auth_providers.dart';
import 'package:ai_chat/features/utou_chat/application/utou_chat_controller.dart';
import 'package:ai_chat/features/utou_chat/domain/utou_chat_model.dart';
import 'package:ai_chat/features/utou_chat/infrastructure/utou_chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// UToUChat repository that interacts with Hive
final uToUChatRepositoryProvider = Provider<UToUChatRepository>(
  (ref) => UToUChatRepository(),
);

/// Get authentication provider functions
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

/// Get User Provider infos
final usersProvider = StreamProvider<List<UserModel>>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.getUsers();
});

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

final messagesProvider = StreamProvider.family<List<UToUChatModel>, String>((
  ref,
  otherUserId,
) {
  final repo = ref.watch(uToUChatRepositoryProvider);
  // final authState = ref.watch(authControllerProvider);
  final authState = ref.read(authControllerProvider);

  final currentUserId = authState.uid;
  // final currentUser = switch (authState) {
  //       Authenticated(user: final user) => (user.),
  //       _ => (UserRole.guest, false),
  //     };
  return repo.getMessages(currentUserId, otherUserId);
});
