import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';

class StatusWidget extends StatelessWidget {
  final String title;
  final int status;
  final TextAlign? textAlign;

  const StatusWidget({
    Key? key,
    required this.title,
    required this.status,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 4.0,
            ),
            decoration: BoxDecoration(
              color: status == 0
                  ? HexColors.additionalViolet
                  : status == 1
                      ? HexColors.additionalDeepBlue
                      : status == 2
                          ? HexColors.additionalGreen
                          : HexColors.grey70,
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Text(title,
                textAlign: textAlign ?? TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'PT Root UI',
                  fontWeight: FontWeight.w500,
                  color: HexColors.white,
                ))));
  }
}
