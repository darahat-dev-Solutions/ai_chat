import 'package:ai_chat/app.dart';
import 'package:ai_chat/core/services/initialization_service.dart';
import 'package:ai_chat/core/utils/logger.dart';
import 'package:ai_chat/features/auth/provider/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Top Level function to handle background messages

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  AppLogger.init();
  final container = ProviderContainer();
  // await dotenv.load(fileName: ".env");
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.debug,
  //   appleProvider: AppleProvider.appAttest,
  // );

  try {
    await container.read(initializationServiceProvider).initialize();
  } catch (e) {
    runApp(
      MaterialApp(
        home: Scaffold(body: Center(child: Text('Initialization failed: $e'))),
      ),
    );
    return;
  }

  container.read(authControllerProvider.notifier).checkInitialAuthState();
  runApp(UncontrolledProviderScope(container: container, child: const App()));
  // final firebaseMessagingService = container.read(
  //   firebaseMessagingServiceProvider,
  // );
  // await firebaseMessagingService.initialize();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // container.read(authControllerProvider.notifier).checkInitialAuthState();

  // runApp(UncontrolledProviderScope(container: container, child: const App()));
}
