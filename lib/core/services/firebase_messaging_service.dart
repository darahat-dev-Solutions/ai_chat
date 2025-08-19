import 'package:ai_chat/app/router.dart';
import 'package:ai_chat/core/utils/logger.dart';
import 'package:ai_chat/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Added GoRouter import

/// Manage Firebase Notifications
class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoRouter _goRouter; // Changed to non-initialized
  /// FirebaseMessagingService constructor
  FirebaseMessagingService(this._goRouter); // Added constructor

  /// Firebase notification initializing configuration
  Future<void> initialize() async {
    /// Request permission for notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    AppLogger.debug('User granted permission: ${settings.authorizationStatus}');

    /// Handle foreground messages
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   AppLogger.debug('Got a message whitelist in the foreground');
    //   AppLogger.debug('Message data: ${message.data}');
    //   if (message.notification != null) {
    //     AppLogger.debug(
    //       'Message also contained a notification: ${message.notification}',
    //     );
    //     // You can display a local notification here using flutter_local_notifications
    //     // or update your UI based on the message
    //   }
    // });

    /// Handle when a user taps on a notification and the app is opened from a terminated state
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) async {
      if (message != null) {
        AppLogger.debug(
          'App opened from terminated state by notification:${message.data}',
        );
        _handleNotificationTap(message); // Call handleNotificationTap
      }
    });

    /// Handle when a user taps on a notification and the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      AppLogger.debug(
        'App Opened from background by notification: ${message.data}',
      );
      _handleNotificationTap(message); // Call handleNotificationTap
    });

    /// Get the device token
    String? token = await _firebaseMessaging.getToken();
    AppLogger.debug('FCM Token: $token');

    /// You might want to send this token to your backend server
    await _saveTokenToDatabase(token);

    /// Listen for token refresh
    _firebaseMessaging.onTokenRefresh.listen(_saveTokenToDatabase);

    /// flutter local notification initializing
    await _initializeLocalNotifications();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AppLogger.debug('Foreground message: ${message.data}');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              channelDescription: 'Used for important notifications',
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });
  }

  Future<void> _saveTokenToDatabase(String? token) async {
    if (token == null) return;
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'fcmToken': token,
      });
    }
  }

  // New method to handle notification taps - moved inside the class
  void _handleNotificationTap(RemoteMessage message) {
    final chatId = message.data['chatId'];
    final type = message.data['type']; // Assuming you have a 'type' field
    /// Assuming you have a type field
    if (type == 'chat' && chatId != null) {
      _goRouter.go('/uToUChat/$chatId');
    }
    // Add more conditions for other notification types if needed
  }
}

/// Firebase Local Notification instance call
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> _initializeLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Reinitialize flutter_local_notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  AppLogger.debug('Background message: ${message.data}');
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = notification?.android;

  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'Used for important notifications',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }
}

/// RiverPod provider for FirebaseMessagingService

final firebaseMessagingServiceProvider = Provider<FirebaseMessagingService>((
  ref,
) {
  final goRouter = ref.watch(routerProvider);
  return FirebaseMessagingService(goRouter);
});
