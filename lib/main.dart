import 'package:ai_chat/app.dart';
import 'package:ai_chat/core/config/env_validator.dart';
import 'package:ai_chat/core/services/firebase_messaging_service.dart';
import 'package:ai_chat/core/services/initialization_service.dart';
import 'package:ai_chat/core/widgets/env_error_widget.dart';
import 'package:ai_chat/features/auth/provider/auth_providers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Top Level function to handle background messages

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  /// Validate environment variables first
  final missingVars = EnvValidator.validateEnv();
  if (missingVars.isNotEmpty) {
    runApp(EnvErrorWidget(missingVars: missingVars));
    return;
  }

  late ProviderContainer container;

  try {
    container = ProviderContainer();
    await container.read(initializationServiceProvider).initialize();
  } catch (e) {
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(navigatorKey.currentContext ??
                                  navigatorKey.currentState!.context)
                              .size
                              .height *
                          0.1,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: Icon(
                        Icons.error_outline,
                        size: 80,
                        color: Colors.red[700],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Initialization Error',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[900],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Something went wrong during app setup',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        border: Border.all(
                          color: Colors.red[200]!,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Error Details:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red[900],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$e',
                            style: TextStyle(
                              color: Colors.red[900],
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        border: Border.all(
                          color: Colors.blue[200]!,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.blue[700]),
                              const SizedBox(width: 8),
                              Text(
                                'What to do:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '1. Check your .env file exists\n'
                            '2. Verify all required variables are set\n'
                            '3. Check Firebase configuration\n'
                            '4. See README.md for setup guide\n'
                            '5. Restart the app',
                            style: TextStyle(
                              color: Colors.blue[900],
                              height: 1.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    return;
  }

  container.read(authControllerProvider.notifier).checkInitialAuthState();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(UncontrolledProviderScope(container: container, child: const App()));
}

final navigatorKey = GlobalKey<NavigatorState>();
