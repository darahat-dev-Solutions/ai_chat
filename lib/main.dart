import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/app.dart';
import 'package:flutter_starter_kit/core/localization/app_localization.dart';
import 'package:flutter_starter_kit/core/services/firebase_messaging_service.dart';
import 'package:flutter_starter_kit/core/services/hive_service.dart';
import 'package:flutter_starter_kit/core/utils/logger.dart';
import 'package:flutter_starter_kit/features/auth/provider/auth_providers.dart';

import 'firebase_options.dart';

/// Top Level function to handle background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// When the app is in the background or terminated, firebase needs to be initialized
  /// before you can use any Firebase services.
  AppLogger.debug('Handling a background message: ${message.messageId}');
  // You can now use the service to handle the message
  FirebaseMessagingService().handleBackgroundMessage(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.init();
  localization.init(
    mapLocales: mapLocales,
    initLanguageCode: 'en', // Default language
  );
  // await dotenv.load();
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

  /// Initialize firebase messaging Service
  final firebaseMessagingService = container.read(
    firebaseMessagingServiceProvider,
  );
  await firebaseMessagingService.initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// Call the new method to safely check the auth state.
  container.read(authControllerProvider.notifier).checkInitialAuthState();
  runApp(UncontrolledProviderScope(container: container, child: App()));
}
