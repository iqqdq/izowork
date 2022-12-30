import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';

class TitleWidget extends StatelessWidget {
  final String text;
  final bool? isSmall;
  final EdgeInsets? padding;

  const TitleWidget({Key? key, required this.text, this.isSmall, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final small = isSmall == null
        ? false
        : isSmall == true
            ? true
            : false;

    return Padding(
        padding: padding == null
            ? const EdgeInsets.symmetric(horizontal: 16.0)
            : padding!,
        child: Text(text,
            style: TextStyle(
                fontSize: small ? 12.0 : 20.0,
                fontWeight: small ? FontWeight.w400 : FontWeight.w700,
                color: small ? HexColors.grey40 : HexColors.black,
                fontFamily: 'PT Root UI')));
  }
}
