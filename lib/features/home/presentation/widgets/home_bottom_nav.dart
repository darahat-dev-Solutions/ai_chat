import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/features/home/provider/home_provider.dart';

/// HomeBottomNav widget class
class HomeBottomNav extends ConsumerWidget {
  /// HomeBottomNav widget constructor
  const HomeBottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(homeControllerProvider).currentTabIndex;
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        ref.read(homeControllerProvider.notifier).changeTab(index);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}
