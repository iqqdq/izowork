import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/main.dart';
import 'package:oktoast/oktoast.dart';

class Toast {
  showTopToast(String message) => showToast(
        message,
        textStyle: TextStyle(
          color: HexColors.white,
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
        textPadding: const EdgeInsets.all(12.0),
        position: const ToastPosition(align: Alignment.topCenter),
        margin: EdgeInsets.only(
          left: 20.0,
          top: navigatorKey.currentContext == null
              ? 30.0
              : MediaQuery.of(navigatorKey.currentContext!).padding.top + 12.0,
          right: 20.0,
        ),
        backgroundColor: HexColors.additionalViolet,
        duration: const Duration(seconds: 5),
        animationCurve: Curves.easeInOut,
      );
}
