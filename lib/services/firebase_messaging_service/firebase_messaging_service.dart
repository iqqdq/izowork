import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:izowork/main.dart';

class FirebaseMessagingService {
  final Function(String?) onTokenReceive;
  final Function(RemoteMessage message) onNotificationRecieve;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FirebaseMessagingService({
    required this.onTokenReceive,
    required this.onNotificationRecieve,
  }) {
    _initialize();
  }

  void _initialize() async {
    await _requestFirebasePermission().then((permission) async => {
          if (permission == true)
            {
              await _requestToken().then((token) => {
                    if (token != null)
                      {
                        // When app in foreground
                        FirebaseMessaging.onMessage.listen((message) =>
                            _showFlutterLocalNotificationPlugin(message)),

                        // When app in background
                        FirebaseMessaging.onMessageOpenedApp.listen(
                            (RemoteMessage message) =>
                                onNotificationRecieve(message)),

                        // When app is terminated
                        FirebaseMessaging.instance
                            .getInitialMessage()
                            .then((message) {
                          if (message != null) {
                            onNotificationRecieve(message);
                          }
                        }),
                      }
                  }),
            }
        });
  }

  Future<bool> _requestFirebasePermission() async {
    if (Platform.isIOS) {
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        return true;
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        return true;
      } else {
        return false;
      }
    }

    return true;
  }

  Future<String?> _requestToken() async {
    final token = await _firebaseMessaging.getToken();
    onTokenReceive(token);

    return token;
  }

  Future _showFlutterLocalNotificationPlugin(RemoteMessage? message) async {
    if (message != null) {
      RemoteMessage localizedMessage = message;
      RemoteNotification? notification = localizedMessage.notification;

      if (notification != null) {
        const AndroidNotificationChannel channel = AndroidNotificationChannel(
          'high_importance__channel',
          'High Importance Notifications',
          description: 'This _channel is used for important notifications.',
          importance: Importance.high,
        );

        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
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
              iOS: const DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              )),
          payload: jsonEncode(message.data),
        );
      }
    }
  }
}
