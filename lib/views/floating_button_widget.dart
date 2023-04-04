import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/hex_colors.dart';

class FloatingButtonWidget extends StatelessWidget {
  final VoidCallback onTap;

  const FloatingButtonWidget({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 48.0,
        width: 48.0,
        decoration: BoxDecoration(
            color: HexColors.primaryMain,
            borderRadius: BorderRadius.circular(24.0)),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                highlightColor: HexColors.primaryDark,
                splashColor: Colors.transparent,
                borderRadius: BorderRadius.circular(24.0),
                child:
                    Center(child: SvgPicture.asset('assets/ic_large_plus.svg')),
                onTap: () => onTap())));
  }
}
