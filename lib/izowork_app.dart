import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/screens/splash/splash_screen.dart';
import 'package:izowork/services/local_storage/local_storage.dart';
import 'package:oktoast/oktoast.dart';

class IzoworkApp extends StatefulWidget {
  const IzoworkApp({super.key});

  @override
  State<IzoworkApp> createState() => _IzoworkAppState();
}

class _IzoworkAppState extends State<IzoworkApp> {
  final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey(debugLabel: "Main Navigator");

  final GetIt _getIt = GetIt.I;

  @override
  void initState() {
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

  Future<dynamic> _onSelectNotification(
      NotificationResponse notificationResponse) async {
    // CHECK USER IS AUTHORIZED
    if (await _getIt<LocalStorageService>().getToken() != null) {
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
