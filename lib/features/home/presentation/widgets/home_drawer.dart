import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/features/auth/provider/auth_providers.dart';
import 'package:flutter_starter_kit/features/home/presentation/widgets/user_profile_header.dart';
import 'package:flutter_starter_kit/features/home/provider/home_provider.dart';
import 'package:flutter_starter_kit/l10n/app_localizations.dart';

/// HomeDrawer for side drawer
class HomeDrawer extends ConsumerWidget {
  /// HomeDrawer container
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Drawer(
      // Explicitly set the background color to ensure it's applied
      backgroundColor: theme.drawerTheme.backgroundColor,
      child: Column(
        children: [
          // Custom DrawerHeader with proper background
          Container(
            height: 200, // Standard drawer header height
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.drawerTheme.backgroundColor,
              border: Border(
                bottom: BorderSide(color: theme.dividerColor, width: 1),
              ),
            ),
            child: const SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: UserProfileHeader(),
              ),
            ),
          ),

          // Menu items with proper background
          Expanded(
            child: Container(
              color: theme.drawerTheme.backgroundColor,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.home,
                      color: theme.colorScheme.onSurface,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.home,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    onTap: () {
                      ref.read(homeControllerProvider.notifier).changeTab(0);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: theme.colorScheme.onSurface,
                    ),
                    title: Text(
                      AppLocalizations.of(
                        context,
                      )!.logout, // Fixed typo from 'Logot'
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    onTap: () {
                      ref.read(authControllerProvider.notifier).signOut();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
