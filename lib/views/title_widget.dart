import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';

class TitleWidget extends StatelessWidget {
  final String text;
  final bool? isSmall;
  final bool? nonSelectable;
  final TextAlign? textAlign;
  final EdgeInsets? padding;

  const TitleWidget({
    Key? key,
    required this.text,
    this.isSmall,
    this.nonSelectable,
    this.textAlign,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool small = isSmall == null
        ? false
        : isSmall == true
            ? true
            : false;

    final bool selectable = nonSelectable == null
        ? true
        : nonSelectable == true
            ? false
            : true;

    final Widget textWidget = Material(
      type: MaterialType.transparency,
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(
          fontSize: small ? 12.0 : 20.0,
          fontWeight: small ? FontWeight.w400 : FontWeight.w700,
          color: small ? HexColors.grey40 : HexColors.black,
          fontFamily: 'PT Root UI',
        ),
      ),
    );

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
      child: small
          ? textWidget
          : selectable
              ? SelectionArea(child: textWidget)
              : textWidget,
    );
  }
}
