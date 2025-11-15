import 'package:ai_chat/features/auth/provider/auth_providers.dart';
import 'package:ai_chat/features/utou_chat/presentation/widgets/chat_bubble.dart';
import 'package:ai_chat/features/utou_chat/provider/utou_chat_providers.dart';
import 'package:ai_chat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// User-to-User Chat View presentation
class UToUChatView extends ConsumerStatefulWidget {
  /// it will take receiverId from user list
  final String receiverId;

  /// It will get receiverName
  final String displayName;

  /// User-to-User Chat View constructor
  const UToUChatView({
    super.key,
    required this.receiverId,
    required this.displayName,
  });

  @override
  ConsumerState<UToUChatView> createState() => _UToUChatViewConsumerState();
}

class _UToUChatViewConsumerState extends ConsumerState<UToUChatView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;
  late FocusNode _focusNode;

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    /// Using a post-frame callback ensures that the list has been built/updated
    /// before we try to scroll
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(WidgetRef ref, String currentUserId) {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      final systemPrompt = AppLocalizations.of(context)!.systemSummaryPrompt;
      ref.read(uToUChatControllerProvider.notifier).addUToUChat(
            text,
            systemPrompt,
            currentUserId,
            widget.receiverId,
          );
      _textController.clear();

      // Reset loading state after a short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatsAsync = ref.watch(messagesProvider(widget.receiverId));
    final currentUser = ref.watch(authControllerProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    /// get Firestore message updates
    ref.listen(messagesProvider(widget.receiverId), (previous, next) {
      if (next.asData != null) {
        _scrollToBottom();
      }
    });

    /// Listen to changes in the chat list when new data arrives scroll to the bottom
    ref.listen(uToUChatControllerProvider, (previous, next) {
      if (next is AsyncData) {
        /// Check if a message was added
        final prevLength = previous?.asData?.value.length ?? 0;
        final currentLength = next.value?.length ?? 0;
        if (currentLength > prevLength) {
          _scrollToBottom();
        }
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: colorScheme.onSurface,
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/users');
            }
          },
        ),
        title: Row(
          children: [
            // Receiver Avatar

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.displayName,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onBackground,
                    ),
                  ),
                  Text(
                    'Offline', // You can replace this with actual status
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert_rounded,
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
            onPressed: () {
              // Handle more options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: chatsAsync.when(
              data: (chats) {
                /// Initial scroll when data first loads
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(
                      _scrollController.position.maxScrollExtent,
                    );
                  }
                });

                // Mark messages as read
                for (var chat in chats) {
                  if (chat.receiverId == currentUser.uid) {
                    ref
                        .read(uToUChatControllerProvider.notifier)
                        .toggleIsReadChat(
                          chat.id,
                          chat.receiverId!,
                          chat.senderId!,
                        );
                  }
                }

                if (chats.isEmpty) {
                  return _buildEmptyState(
                      theme, colorScheme, textTheme, context);
                }

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
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      final isCurrentUser = chat.senderId == currentUser.uid;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ChatBubble(
                            chat: chat, isCurrentUser: isCurrentUser),
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
          _buildMessageInput(
            ref,
            _textController,
            context,
            currentUser.uid ?? '',
            theme,
            colorScheme,
            textTheme,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, ColorScheme colorScheme,
      TextTheme textTheme, BuildContext context) {
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
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: colorScheme.primary,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Start a Conversation',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onBackground,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Send your first message to ${widget.displayName} and start chatting!',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Tips for great conversations:',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTipItem(
                      'Be friendly and respectful',
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                    const SizedBox(height: 8),
                    _buildTipItem(
                      'Ask open-ended questions',
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                    const SizedBox(height: 8),
                    _buildTipItem(
                      'Share your thoughts and ideas',
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipItem(String text,
      {required ColorScheme colorScheme, required TextTheme textTheme}) {
    return Row(
      children: [
        Icon(
          Icons.check_circle_rounded,
          color: colorScheme.primary,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState(
      ThemeData theme, ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading messages...',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object err, ThemeData theme, ColorScheme colorScheme,
      TextTheme textTheme) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: colorScheme.error,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load chat',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onBackground,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Error: $err',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Retry logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Try Again',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(
    WidgetRef ref,
    TextEditingController textController,
    BuildContext context,
    String currentUserId,
    ThemeData theme,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final typeMessage = AppLocalizations.of(context)!.typeMessage;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Emoji/Attachment button
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: IconButton(
              icon: Icon(
                Icons.emoji_emotions_outlined,
                color: colorScheme.onSurface.withOpacity(0.6),
                size: 20,
              ),
              onPressed: () {
                // Handle emoji/attachment
              },
            ),
          ),
          const SizedBox(width: 12),

          // Message input field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: typeMessage,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  hintStyle: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
                maxLines: 5,
                minLines: 1,
                onSubmitted: (text) {
                  if (text.trim().isNotEmpty && !_isLoading) {
                    _sendMessage(ref, currentUserId);
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Send button
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _isLoading
                  ? colorScheme.onSurface.withOpacity(0.2)
                  : colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onPrimary,
                      ),
                    )
                  : Icon(
                      Icons.send_rounded,
                      color: colorScheme.onPrimary,
                      size: 20,
                    ),
              onPressed: _isLoading
                  ? null
                  : () {
                      _sendMessage(ref, currentUserId);
                    },
            ),
          ),
        ],
      ),
    );
  }
}
