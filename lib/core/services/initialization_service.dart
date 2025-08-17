import 'package:ai_chat/core/services/firebase_messaging_service.dart';
import 'package:ai_chat/core/services/hive_service.dart';
import 'package:ai_chat/firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InitializationService {
  final Ref _ref;
  InitializationService(this._ref);

  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.appAttest,
    );
    await HiveService.init();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(initSettings);
    final messagingService = _ref.read(firebaseMessagingServiceProvider);
    await messagingService.initialize();

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
}

final initializationServiceProvider = Provider<InitializationService>(
  (ref) => InitializationService(ref),
);
