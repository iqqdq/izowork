import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:izowork/components/custom_scroll_behavior.dart';
import 'package:izowork/models/notifications_view_model.dart';
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
  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    _flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings(
          '@mipmap/ic_launcher',
        ),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (details) =>
          onSelectNotification(details),
    );

    super.initState();
  }

  Future<dynamic> onSelectNotification(
      NotificationResponse notificationResponse) async {
    String? token = await LocalService().getToken();
    if (token != null) {
      if (notificationResponse.payload != null) {
        Map payload = jsonDecode(notificationResponse.payload!);

        if (payload['action'] == 'izowork_notification') {
          if (_navigatorKey.currentContext != null) {
            NotificationsViewModel().readNotification(
              _navigatorKey.currentContext!,
              payload['id'],
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
