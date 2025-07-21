import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/features/home/provider/home_provider.dart';
import 'package:flutter_starter_kit/l10n/app_localizations.dart';

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
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: AppLocalizations.of(context)!.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.search),
          label: AppLocalizations.of(context)!.search,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings),
          label: AppLocalizations.of(context)!.settings,
        ),
      ],
    );
  }
}
