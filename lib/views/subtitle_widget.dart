import 'package:flutter/material.dart';

class SubtitleWidget extends StatelessWidget {
  final String text;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final EdgeInsets? padding;
  final Color? titleColor;

  const SubtitleWidget(
      {Key? key,
      required this.text,
      this.fontWeight,
      this.textAlign,
      this.padding,
      this.titleColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding == null
            ? const EdgeInsets.symmetric(horizontal: 16.0)
            : padding!,
        child: Text(text,
            textAlign: textAlign,
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: fontWeight ?? FontWeight.w400,
                fontFamily: 'PT Root UI',
                color: titleColor)));
  }
}
