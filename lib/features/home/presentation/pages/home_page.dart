import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/features/auth/provider/auth_providers.dart';
import 'package:go_router/go_router.dart';

/// Landing Page After Login
class HomePage extends ConsumerStatefulWidget {
  /// Landing page/Home Page Constructor
  const HomePage({super.key});
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Future<void> _handleLogout() async {
    final auth = ref.read(authControllerProvider.notifier);
    await auth.signOut();
    if (!mounted) return; // Ensure widget is still in the tree
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _handleLogout),
        ],
      ),
      body: const Center(
        child: Text('Welcome! The tasks feature is currently disabled.'),
      ),
    );
  }
}
