import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:oktoast/oktoast.dart';

class Toast {
  showTopToast(BuildContext context, String message) {
    showToast(message,
        textStyle: TextStyle(
            color: HexColors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.w400),
        textPadding: const EdgeInsets.all(11.0),
        position: const ToastPosition(align: Alignment.topCenter),
        margin: EdgeInsets.only(
            left: 16.0,
            top: MediaQuery.of(context).padding.top == 0.0
                ? 30.0
                : MediaQuery.of(context).padding.top,
            right: 20.0),
        backgroundColor: HexColors.additionalViolet,
        duration: const Duration(seconds: 5),
        animationCurve: Curves.easeInOut);
  }
}
