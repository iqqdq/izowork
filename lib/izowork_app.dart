import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badge/flutter_app_badge.dart';

import 'package:oktoast/oktoast.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/main.dart';
import 'package:izowork/features/splash/view/splash_screen.dart';

// Register the RouteObserver as a navigation observer.
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

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
        navigatorObservers: [routeObserver],
        home: const SplashScreenWidget(),
      ),
    );
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void _removeAppBadger() async => await FlutterAppBadge.count(0);
}
