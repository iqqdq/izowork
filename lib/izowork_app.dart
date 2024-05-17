import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/main.dart';
import 'package:izowork/screens/splash/splash_screen.dart';
import 'package:oktoast/oktoast.dart';

class IzoworkApp extends StatelessWidget {
  const IzoworkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        navigatorKey: navigatorKey,
        scrollBehavior: CustomScrollBehavior(),
        theme: ThemeData(
          appBarTheme:
              const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.dark),
        ),
        home: const SplashScreenWidget(),
      ),
    );
  }
}
