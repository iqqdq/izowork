import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badge/flutter_app_badge.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/izowork_app.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) =>
    selectNotificationStream.add(notificationResponse.payload);

Future firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await FlutterAppBadge.count(1);

  await Firebase.initializeApp(
    name: 'Izowork',
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init depencies
  await initializeDependencies();

  // Init firebase app
  await Firebase.initializeApp(
    name: 'Izowork',
    options: Platform.isIOS
        ? DefaultFirebaseOptions.ios
        : DefaultFirebaseOptions.android,
  );

  // Set device orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Clear app badge
  await FlutterAppBadge.count(0);

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Init Flutter Local Notification Plugin
  await flutterLocalNotificationsPlugin.initialize(
    InitializationSettings(
      android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        onDidReceiveLocalNotification: (
          int id,
          String? title,
          String? body,
          String? payload,
        ) async =>
            didReceiveLocalNotificationStream.add(ReceivedNotification(
          id: id,
          title: title,
          body: body,
          payload: payload,
        )),
      ),
    ),
    onDidReceiveNotificationResponse: notificationTapBackground,
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  runApp(const IzoworkApp());
}
