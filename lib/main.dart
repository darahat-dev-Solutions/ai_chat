import 'package:ai_chat/app.dart';
import 'package:ai_chat/core/services/firebase_messaging_service.dart';
import 'package:ai_chat/core/services/hive_service.dart';
import 'package:ai_chat/core/utils/logger.dart';
import 'package:ai_chat/features/auth/provider/auth_providers.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );

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

  final container = ProviderContainer();

  final firebaseMessagingService = container.read(
    firebaseMessagingServiceProvider,
  );
  await firebaseMessagingService.initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  container.read(authControllerProvider.notifier).checkInitialAuthState();

  runApp(UncontrolledProviderScope(container: container, child: const App()));
}
