import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';

class TransparentButtonWidget extends StatelessWidget {
  final String title;
  final double? fontSize;
  final EdgeInsets? margin;
  final VoidCallback onTap;

  const TransparentButtonWidget(
      {Key? key,
      required this.title,
      this.fontSize,
      this.margin,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: margin == null
            ? const EdgeInsets.symmetric(horizontal: 16.0)
            : margin!,
        height: 54.0,
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                highlightColor: HexColors.grey10,
                splashColor: Colors.transparent,
                borderRadius: BorderRadius.circular(16.0),
                child: Center(
                    child: Text(title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: fontSize ?? 18.0,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: 'PT Root UI',
                            fontWeight: FontWeight.bold,
                            color: HexColors.primaryDark))),
                onTap: () => onTap())));
  }
}
