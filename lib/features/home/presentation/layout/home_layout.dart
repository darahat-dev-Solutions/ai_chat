import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/features/home/presentation/pages/home_page.dart';
import 'package:flutter_starter_kit/features/home/presentation/pages/setting_page.dart';
import 'package:flutter_starter_kit/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:flutter_starter_kit/features/home/presentation/widgets/home_drawer.dart';
import 'package:flutter_starter_kit/features/home/presentation/widgets/search_content.dart';
import 'package:flutter_starter_kit/features/home/provider/home_provider.dart';

/// Home Layout (bottom navigation+sidebar+topBar+scrollable body)
class HomeLayout extends ConsumerWidget {
  /// Landing page/Home Page Constructor
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(homeControllerProvider).currentTabIndex;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', textAlign: TextAlign.center),
        centerTitle: true,
        leading: Builder(
          builder:
              (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.menu),
              ),
        ),
      ),
      drawer: const HomeDrawer(),
      body: IndexedStack(
        index: currentIndex,
        children: [HomePage(), SearchContent(), SettingsPage()],
      ),
      bottomNavigationBar: const HomeBottomNav(),
    );
  }
}
