import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';

class CheckWidget extends StatelessWidget {
  final bool isReady;

  const CheckWidget({Key? key, required this.isReady}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 20.0,
        height: 20.0,
        decoration: BoxDecoration(
            color: isReady ? HexColors.primaryMain : HexColors.grey20,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
                width: isReady ? 2.0 : 0.0,
                color: isReady ? HexColors.grey40 : Colors.transparent)),
        child: Center(child: Image.asset('assets/ic_checkmark.png')));
  }
}
