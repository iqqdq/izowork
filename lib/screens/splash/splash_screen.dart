import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/user_params.dart';
import 'package:izowork/screens/authorization/authorization_screen.dart';
import 'package:izowork/screens/tab_controller/tab_controller_screen_body.dart';
import 'package:izowork/views/loading_indicator_widget.dart';

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
    _isTokenExist = (await UserParams().getToken())?.isNotEmpty ?? false;
  }

  void _push() async {
    Future.delayed(
        const Duration(seconds: 2),
        () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => _isTokenExist
                    ? const TabControllerScreenWidget()
                    : const TabControllerScreenWidget()),
            // ? const TabControllerScreenWidget()
            // : const AuthorizationScreenWidget()),
            (route) => false));
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
          Center(child: Image.asset('assets/logo.png')),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom == 0.0
                          ? 12.0
                          : MediaQuery.of(context).padding.bottom),
                  child: const LoadingIndicatorWidget(onlyIndicator: true)))
        ]))));
  }
}
