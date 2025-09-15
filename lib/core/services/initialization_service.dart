import 'dart:io';

import 'package:ai_chat/core/services/hive_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Initialization Service class
/// where all kind of Initialization takes places

class InitializationService {
  /// Ref is used to any provider or service to connect with other provider/service
  final Ref ref;

  /// Initialization Service Constructor
  InitializationService(this.ref);

  /// Main Initialize function
  Future<void> initialize() async {
    /// Ensure Flutter binding is initialized

    /// Register background message handler
    await dotenv.load(fileName: ".env");
    await Firebase.initializeApp();
    if (dotenv.env['USE_FIREBASE_EMULATOR'] == 'true') {
      // For Android emulator use 10.0.2.2. for iOS use localhost.
      final host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
      await FirebaseAuth.instance.useAuthEmulator(host, 9099);
      FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
    } else {
      //Only activate App Check when not using the emulator/cloud Firebase.
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug,
        appleProvider: AppleProvider.appAttest,
      );
    }

    // await FirebaseAppCheck.instance.activate(
    //   androidProvider: AndroidProvider.debug,
    //   appleProvider: AppleProvider.appAttest,
    // );
    await ref.read(hiveServiceProvider).init();
  }
}

/// initializationServiceProvider provider variable
final initializationServiceProvider = Provider<InitializationService>(
  (ref) => InitializationService(ref),
);
