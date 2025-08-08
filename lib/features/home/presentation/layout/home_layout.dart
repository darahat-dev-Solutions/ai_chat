import 'package:ai_chat/features/app_settings/presentation/pages/setting_page.dart';
import 'package:ai_chat/features/home/presentation/pages/home_page.dart';
import 'package:ai_chat/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:ai_chat/features/home/presentation/widgets/home_drawer.dart';
import 'package:ai_chat/features/home/presentation/widgets/search_content.dart';
import 'package:ai_chat/features/home/provider/home_provider.dart';
import 'package:ai_chat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Home Layout (bottom navigation+sidebar+topBar+scrollable body)
class HomeLayout extends ConsumerWidget {
  /// Landing page/Home Page Constructor
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(homeControllerProvider).currentTabIndex;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.home,
          textAlign: TextAlign.center,
        ),
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
