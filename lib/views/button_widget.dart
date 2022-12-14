import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final bool? isDisabled;
  final bool? isTransparent;
  final VoidCallback onTap;

  const ButtonWidget(
      {Key? key,
      required this.title,
      this.isDisabled,
      this.isTransparent,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _isDisabled = isDisabled == null
        ? false
        : isDisabled!
            ? true
            : false;

    final _isTransparent = isTransparent == null
        ? false
        : isTransparent!
            ? true
            : false;

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        height: 54.0,
        decoration: BoxDecoration(
            color: _isDisabled
                ? HexColors.grey20
                : _isTransparent
                    ? Colors.transparent
                    : HexColors.primaryMain,
            borderRadius: BorderRadius.circular(16.0)),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                highlightColor: HexColors.primaryDark,
                borderRadius: BorderRadius.circular(16.0),
                child: Center(
                    child: Text(title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18.0,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: 'PT Root UI',
                            fontWeight: FontWeight.w700,
                            color: HexColors.black))),
                onTap: () => onTap())));
  }
}
