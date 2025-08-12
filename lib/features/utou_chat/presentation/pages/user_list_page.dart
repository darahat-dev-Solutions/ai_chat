import 'package:ai_chat/features/auth/provider/auth_providers.dart';
import 'package:ai_chat/features/utou_chat/presentation/pages/utou_chat_view.dart';
import 'package:ai_chat/features/utou_chat/provider/utou_chat_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// All User Account registered will show
class UserListPage extends ConsumerWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsyncValue = ref.watch(usersProvider);
    final currentUser = ref.watch(authControllerProvider).uid;
    return usersAsyncValue.when(
      data: (users) {
        final otherUsers =
            users.where((user) => user.uid != currentUser).toList();
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final userData = user as Map<String, dynamic>;
            final displayName =
                userData.containsKey('displayName')
                    ? userData['displayName']
                    : 'No Name';
            return ListTile(
              title: Text(displayName),
              onTap: () {
                MaterialPageRoute(
                  builder:
                      (context) => UToUChatView(
                        receiverId: user.uid,
                        receiverName: user.name ?? 'No Name',
                      ),
                );
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}
