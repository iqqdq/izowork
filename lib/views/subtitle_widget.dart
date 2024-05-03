import 'package:flutter/material.dart';

class SubtitleWidget extends StatelessWidget {
  final String text;
  final bool? nonSelectable;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final EdgeInsets? padding;
  final Color? titleColor;

  const SubtitleWidget({
    Key? key,
    required this.text,
    this.nonSelectable,
    this.fontWeight,
    this.textAlign,
    this.padding,
    this.titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool selectable = nonSelectable == null
        ? true
        : nonSelectable == true
            ? false
            : true;

    Widget textWidget = Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: 14.0,
        fontWeight: fontWeight ?? FontWeight.w400,
        fontFamily: 'PT Root UI',
        color: titleColor,
      ),
    );

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
      child: selectable ? SelectionArea(child: textWidget) : textWidget,
    );
  }
}
