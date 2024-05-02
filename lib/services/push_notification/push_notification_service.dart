import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:izowork/firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:izowork/services/push_notification/abstract_push_notification_service.dart';

class PushNotificationServiceImpl extends PushNotificationService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  @override
  Future setupFlutterLocalNotificationsPlugin() async {
    // Update the iOS foreground notification presentation options to allow heads up notifications.
    if (Platform.isIOS) {
      await firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteMessage localizedMessage = message;
      RemoteNotification? notification = localizedMessage.notification;

      if (notification != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          Platform.isIOS ? '' : notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: '@mipmap/ic_launcher',
                largeIcon: const DrawableResourceAndroidBitmap(
                  '@mipmap/launcher_icon',
                ),
              ),
              iOS: DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
                subtitle: notification.body,
              )),
          payload: jsonEncode(message.data),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');
      FlutterAppBadger.removeBadge();
    });
  }

  @override
  Future<String?> getDeviceToken() async => await firebaseMessaging.getToken();

  @override
  Future deleteDeviceToken() async => await firebaseMessaging.deleteToken();

  Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp(
      name: 'Izowork',
      options: DefaultFirebaseOptions.currentPlatform,
    );

    debugPrint('Handling a background message ${message.messageId}');
  }
}
