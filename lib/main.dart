import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/app.dart';
import 'package:flutter_starter_kit/core/services/hive_service.dart';
import 'package:flutter_starter_kit/core/utils/logger.dart';
import 'package:flutter_starter_kit/features/auth/provider/auth_providers.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.init();

  await dotenv.load();
  // // Load environment variables
  //   await EnvConfig.load();
  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Activate App Check
  await FirebaseAppCheck.instance
  // Your personal reCaptcha public key goes here:
  .activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest, // Recommended for iOS
  );
  // Initialize Hive with error handling
  try {
    await HiveService.init();
  } catch (e) {
    runApp(
      MaterialApp(
        home: Scaffold(body: Center(child: Text('Initialization failed: $e'))),
      ),
    );
    return;
  }
  // Create a ProviderContainer to access providers before the app runs.
  final container = ProviderContainer();

  /// Call the new method to safely check the auth state.
  container.read(authControllerProvider.notifier).checkInitialAuthState();
  runApp(UncontrolledProviderScope(container: container, child: App()));
}
