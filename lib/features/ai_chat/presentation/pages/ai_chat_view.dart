import 'package:ai_chat/features/ai_chat/presentation/widgets/chatBubble.dart';
import 'package:ai_chat/features/ai_chat/provider/ai_chat_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AiChatView extends ConsumerStatefulWidget {
  const AiChatView({super.key});

  @override
  ConsumerState<AiChatView> createState() => _AiChatViewConsumerState();
}

class _AiChatViewConsumerState extends ConsumerState<AiChatView> {
  late ScrollController _scrollController;
  late TextEditingController _textController;
  late FocusNode _focusNode;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _textController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    // Dispose in the correct order
    _focusNode.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(WidgetRef ref) {
    final text = _textController.text.trim();
    if (text.isNotEmpty && mounted) {
      setState(() {
        _isLoading = true;
      });

      ref.read(aiChatControllerProvider.notifier).addAiChat(text);
      _textController.clear();

      // Unfocus keyboard after sending
      _focusNode.unfocus();

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _scrollToBottom();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatsAsync = ref.watch(aiChatControllerProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    ref.listen(aiChatControllerProvider, (previous, next) {
      if (mounted && next is AsyncData) {
        final prevLength = previous?.asData?.value.length ?? 0;
        final currentLength = next.value?.length ?? 0;
        if (currentLength > prevLength) {
          _scrollToBottom();
        }
      }
    });

    return Column(
      children: [
        Expanded(
          child: chatsAsync.when(
            data: (chats) {
              if (chats.isEmpty) {
                return _buildEmptyState(theme, colorScheme, textTheme, context);
              }

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && _scrollController.hasClients) {
                  _scrollController.jumpTo(
                    _scrollController.position.maxScrollExtent,
                  );
                }
              });

              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colorScheme.primary.withOpacity(0.02),
                      colorScheme.surface.withOpacity(0.5),
                    ],
                  ),
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ChatBubble(chat: chat),
                    );
                  },
                ),
              );
            },
            loading: () => _buildLoadingState(theme, colorScheme, textTheme),
            error: (err, stack) =>
                _buildErrorState(err, theme, colorScheme, textTheme),
          ),
        ),
        _buildMessageInput(ref, _textController, _focusNode, context, theme,
            colorScheme, textTheme),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme, ColorScheme colorScheme,
      TextTheme textTheme, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat,
              size: 64, color: colorScheme.primary.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text('Start a conversation!', style: textTheme.headlineSmall),
        ],
      ),
    );
  }

  Widget _buildLoadingState(
      ThemeData theme, ColorScheme colorScheme, TextTheme textTheme) {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorState(Object err, ThemeData theme, ColorScheme colorScheme,
      TextTheme textTheme) {
    return Center(
      child: Text('Error: $err',
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.error)),
    );
  }

  Widget _buildMessageInput(
      WidgetRef ref,
      TextEditingController controller,
      FocusNode focusNode,
      BuildContext context,
      ThemeData theme,
      ColorScheme colorScheme,
      TextTheme textTheme) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 8,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              maxLines: null,
              enabled: !_isLoading,
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            mini: true,
            onPressed: _isLoading ? null : () => _sendMessage(ref),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
