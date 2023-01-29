import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';

class CheckBoxWidget extends StatelessWidget {
  final bool isChecked;

  const CheckBoxWidget({Key? key, required this.isChecked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 20.0,
        height: 20.0,
        decoration: BoxDecoration(
            color: isChecked ? HexColors.primaryMain : Colors.transparent,
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(
                width: isChecked ? 0.0 : 2.0,
                color: isChecked ? Colors.transparent : HexColors.primaryMain)),
        child: isChecked
            ? Center(child: Image.asset('assets/ic_checkmark.png'))
            : Container());
  }
}
