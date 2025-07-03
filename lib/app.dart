import 'package:flutter/material.dart';
import 'package:opsmate/app/router.dart';
import 'package:opsmate/app/theme/app_theme.dart';

class App extends StatelessWidget {
  /// Creates an instance of [App]
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'OpsMate',
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
