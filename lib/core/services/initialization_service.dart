import 'package:ai_chat/core/services/hive_service.dart';
import 'package:ai_chat/firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Initialization Service class
/// where all kind of Initialization takes places

class InitializationService {
  final Ref _ref;

  /// Initialization Service Constructor
  InitializationService(this._ref);

  /// Main Initialize function
  Future<void> initialize() async {
    /// Ensure Flutter binding is initialized

    /// Register background message handler
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
    // await flutterLocalNotificationsPlugin.initialize(initSettings);

    // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
}

/// initializationServiceProvider provider variable
final initializationServiceProvider = Provider<InitializationService>(
  (ref) => InitializationService(ref),
);
