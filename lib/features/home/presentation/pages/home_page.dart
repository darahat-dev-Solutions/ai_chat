import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/features/auth/application/auth_state.dart';
import 'package:flutter_starter_kit/features/auth/provider/auth_providers.dart';
import 'package:go_router/go_router.dart';

/// Landing Page After Login
class HomePage extends ConsumerWidget {
  /// Landing page/Home Page Constructor
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(authControllerProvider, (prev, next) {
      if (next is AuthSignedOut) {
        context.go('/login');
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authControllerProvider.notifier).signOut();
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome! The tasks feature is currently disabled.'),
      ),
    );
  }
}
