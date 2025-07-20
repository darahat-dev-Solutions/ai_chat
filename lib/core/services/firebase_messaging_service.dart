import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/core/utils/logger.dart';

/// Manage Firebase Notifications
class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

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
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AppLogger.debug('Got a message whitelist in the foreground');
      AppLogger.debug('Message data: ${message.data}');
      if (message.notification != null) {
        AppLogger.debug(
          'Message also contained a notification: ${message.notification}',
        );
        // You can display a local notification here using flutter_local_notifications
        // or update your UI based on the message
      }
    });

    /// Handle when a user taps on a notification and the app is opened from a terminated state
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) async {
      if (message != null) {
        AppLogger.debug(
          'App opened from terminated state by notification:${message.data}',
        );
      }
    });

    /// Handle when a user taps on a notification and the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      AppLogger.debug(
        'App Opened from background by notification: ${message.data}',
      );
    });

    /// Get the device token
    String? token = await _firebaseMessaging.getToken();
    AppLogger.debug('FCM Token: $token');

    /// You might want to send this token to your backend server

    /// flutter local notification initializing
    await _initializeLocalNotifications();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AppLogger.debug('Got a message in the forground');
      AppLogger.debug('Message data: ${message.data}');
      if (message.notification != null) {
        AppLogger.debug(
          'Message also contained a notification: ${message.notification}',
        );
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                'high_importance_channel',
                'High Importantce Notifications',
                channelDescription: 'Used for important notifications',
                importance: Importance.max,
                priority: Priority.high,
                icon: '@mipmap/ic_launcher',
              ),
            ),
          );
        }
      }
    });
  }

  /// This method will be called by the top-level background handler
  void handleBackgroundMessage(RemoteMessage message) {
    AppLogger.debug('Handling a background message: ${message.messageId}');
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

/// RiverPod provider for FirebaseMessagingService
final firebaseMessagingServiceProvider = Provider<FirebaseMessagingService>((
  ref,
) {
  return FirebaseMessagingService();
});
