import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:izowork/components/fade_page_route.dart';
import 'package:izowork/services/local_service.dart';
import 'package:izowork/screens/authorization/authorization_screen.dart';
import 'package:izowork/screens/tab_controller/tab_controller_screen.dart';

class SplashScreenWidget extends StatefulWidget {
  const SplashScreenWidget({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenWidget> {
  late bool _isTokenExist;

  @override
  void initState() {
    super.initState();

    _validate().then((value) => _push());
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future _validate() async {
    _isTokenExist = (await LocalService().getToken())?.isNotEmpty ?? false;
  }

  void _push() async {
    Navigator.pushAndRemoveUntil(
        context,
        FadePageRoute(_isTokenExist
            ? const TabControllerScreenWidget()
            : const AuthorizationScreenWidget()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 0.0,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent),
        body: SafeArea(
            child: SizedBox.expand(
                child: Stack(children: [
          Center(child: SvgPicture.asset('assets/ic_logo.svg'))
        ]))));
  }
}
