import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final EdgeInsets? margin;
  final bool? isDisabled;
  final VoidCallback onTap;

  const ButtonWidget(
      {Key? key,
      required this.title,
      this.margin,
      this.isDisabled,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _isDisabled = isDisabled == null
        ? false
        : isDisabled!
            ? true
            : false;

    return Container(
        margin: margin == null
            ? const EdgeInsets.symmetric(horizontal: 16.0)
            : margin!,
        height: 54.0,
        decoration: BoxDecoration(
            color: _isDisabled ? HexColors.grey20 : HexColors.primaryMain,
            borderRadius: BorderRadius.circular(16.0)),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                highlightColor: HexColors.primaryDark,
                splashColor: Colors.transparent,
                borderRadius: BorderRadius.circular(16.0),
                child: Center(
                    child: Text(title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18.0,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: 'PT Root UI',
                            fontWeight: FontWeight.bold,
                            color: _isDisabled
                                ? HexColors.grey40
                                : HexColors.black))),
                onTap: _isDisabled ? null : () => onTap())));
  }
}
