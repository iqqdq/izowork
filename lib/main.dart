import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/screens/splash/splash_screen.dart';
import 'package:oktoast/oktoast.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(const IzoworkApp()));
}

class IzoworkApp extends StatelessWidget {
  const IzoworkApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const OKToast(child: MaterialApp(home: SplashScreenWidget()));
  }
}
