import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/screens/splash/splash_screen.dart';
import 'package:izowork/services/push_notification_service.dart';
import 'package:izowork/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:oktoast/oktoast.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase.initializeApp(
  //   name: 'Izowork',
  //   options: Platform.isIOS
  //       ? DefaultFirebaseOptions.ios
  //       : DefaultFirebaseOptions.android,
  // ).whenComplete(() => PushNotificationService().init());

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(const IzoworkApp()));
}

class IzoworkApp extends StatelessWidget {
  const IzoworkApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        scrollBehavior: MyCustomScrollBehavior(),
        home: const SplashScreenWidget(),
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) =>
      child;
}
