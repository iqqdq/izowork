import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/user_params.dart';
import 'package:izowork/screens/deal_calendar/deal_calendar_screen.dart';
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
                    ? const DealCalendarScreenWidget()
                    : const DealCalendarScreenWidget()),
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
          const Align(
              alignment: Alignment.bottomCenter,
              child: LoadingIndicatorWidget(onlyIndicator: true))
        ]))));
  }
}
