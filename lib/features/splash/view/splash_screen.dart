import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:izowork/components/fade_page_route.dart';
import 'package:izowork/features/authorization/view/authorization_screen.dart';
import 'package:izowork/features/tab_controller/view/tab_controller_screen.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/repositories/repositories.dart';

class SplashScreenWidget extends StatefulWidget {
  const SplashScreenWidget({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenWidget> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 300), () => _showStartScreen());
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void _showStartScreen() async {
    final startScreen =
        await sl<LocalStorageRepositoryInterface>().getToken() == null
            ? const AuthorizationScreenWidget()
            : const TabControllerScreenWidget();

    Navigator.pushAndRemoveUntil(
      context,
      FadePageRoute(startScreen),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: Stack(children: [
            Center(child: SvgPicture.asset('assets/ic_logo.svg'))
          ]),
        ),
      ),
    );
  }
}
