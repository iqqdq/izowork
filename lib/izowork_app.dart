import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:oktoast/oktoast.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/main.dart';
import 'package:izowork/features/splash/view/splash_screen.dart';

class IzoworkApp extends StatefulWidget {
  const IzoworkApp({super.key});

  @override
  State<IzoworkApp> createState() => _IzoworkAppState();
}

class _IzoworkAppState extends State<IzoworkApp> {
  @override
  void initState() {
    super.initState();

    _removeAppBadger();
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        navigatorKey: navigatorKey,
        scrollBehavior: CustomScrollBehavior(),
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            surfaceTintColor: Colors.transparent,
            elevation: 0.0,
          ),
        ),
        home: const SplashScreenWidget(),
      ),
    );
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void _removeAppBadger() async {
    await FlutterAppBadger.isAppBadgeSupported()
        .then((value) => FlutterAppBadger.removeBadge());
  }
}
