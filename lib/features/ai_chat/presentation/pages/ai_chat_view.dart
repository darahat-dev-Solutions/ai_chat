import 'package:ai_chat/features/ai_chat/provider/ai_chat_providers.dart';
import 'package:ai_chat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/ChatBubble.dart'; // Import the new widget

class AiChatView extends ConsumerWidget {
  const AiChatView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatsAsync = ref.watch(aiChatControllerProvider);
    final textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.aiGeneratedSummary),
      ),
      body: Column(
        children: [
          Expanded(
            child: chatsAsync.when(
              data: (chats) {
                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    return ChatBubble(chat: chat);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
          _buildMessageInput(ref, textController, context),
        ],
      ),
    );
  }

  Widget _buildMessageInput(
    WidgetRef ref,
    TextEditingController textController,
    BuildContext context,
  ) {
    final systemPrompt = AppLocalizations.of(context)!.systemSummaryPrompt;
    final userPromptPrefix = AppLocalizations.of(context)!.userSummaryPrompt;
    final systemQuickReplyPrompt =
        AppLocalizations.of(context)!.systemQuickReplyPrompt;
    final errorMistralRequest =
        AppLocalizations.of(context)!.errorMistralRequest;
    final typeMessage = AppLocalizations.of(context)!.typeMessage;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: typeMessage,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              final text = textController.text;
              if (text.isNotEmpty) {
                ref
                    .read(aiChatControllerProvider.notifier)
                    .addAiChat(
                      text,
                      systemPrompt,
                      userPromptPrefix,
                      systemQuickReplyPrompt,
                      errorMistralRequest,
                    );
                textController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
