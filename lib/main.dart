import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:izowork/components/custom_scroll_behavior.dart';
import 'package:izowork/entities/response/notification.dart';
import 'package:izowork/models/notifications_view_model.dart';
import 'package:izowork/repositories/fcm_token_repository.dart';
import 'package:izowork/screens/splash/splash_screen.dart';
import 'package:izowork/services/local_service.dart';
import 'package:izowork/services/push_notification_service.dart';
import 'package:izowork/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:oktoast/oktoast.dart';

final GlobalKey<NavigatorState> _navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp(
    name: 'Izowork',
    options: Platform.isIOS
        ? DefaultFirebaseOptions.ios
        : DefaultFirebaseOptions.android,
  ).whenComplete(() => PushNotificationService().init());

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(const IzoworkApp()));
}

class IzoworkApp extends StatefulWidget {
  const IzoworkApp({super.key});

  @override
  State<IzoworkApp> createState() => _IzoworkAppState();
}

class _IzoworkAppState extends State<IzoworkApp> {
  @override
  void initState() {
    // UPDATE DEVICE TOKEN
    _updateDeviceToken();

    // INIT LOCAL NOTIFICATION'S
    FlutterLocalNotificationsPlugin().initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings(
          '@mipmap/ic_launcher',
        ),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (details) =>
          _onSelectNotification(details),
    );

    super.initState();
  }

  Future _updateDeviceToken() async {
    // DELETE CURRENT DEVICE TOKEN FROM FIREBASE
    PushNotificationService pushNotificationService = PushNotificationService();
    await pushNotificationService.deleteDeviceToken();

    // GET NEW DEVICE TOKEN FROM FIREBASE
    String? deviceToken = await pushNotificationService.getDeviceToken();

    // SEND NEW DEVICE TOKEN ON DATABASE
    if (deviceToken != null) {
      await FcmTokenRepository().sendDeviceToken(deviceToken);
    }
  }

  Future<dynamic> _onSelectNotification(
      NotificationResponse notificationResponse) async {
    // CHECK USER IS AUTHORIZED
    if (await LocalService().getToken() != null) {
      // CHECK PUSH NOTIFICATION PAYLOAD
      if (notificationResponse.payload != null) {
        Map<String, dynamic>? payload =
            jsonDecode(notificationResponse.payload!);
        if (payload != null) {
          // CHECK IF PAYLOAD CONTAINS APP's NOTIFICATION ID

          if (_navigatorKey.currentContext != null) {
            // READ & OPEN NOTIFICATION
            NotificationsViewModel().readNotification(
              context,
              true,
              NotificationEntity.fromJson(payload),
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        scrollBehavior: CustomScrollBehavior(),
        home: const SplashScreenWidget(),
      ),
    );
  }
}
