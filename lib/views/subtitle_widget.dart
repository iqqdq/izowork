import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';

class SubtitleWidget extends StatelessWidget {
  final String text;
  final EdgeInsets? padding;

  const SubtitleWidget({Key? key, required this.text, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding == null
            ? const EdgeInsets.symmetric(horizontal: 16.0)
            : padding!,
        child: Text(text,
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: HexColors.black,
                fontFamily: 'PT Root UI')));
  }
}
