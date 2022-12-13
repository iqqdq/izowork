import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';

class BackButtonWidget extends StatelessWidget {
  final VoidCallback onTap;

  const BackButtonWidget({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Image.asset('assets/ic_back_arrow.png',
            color: HexColors.primaryDark, width: 24.0, height: 24.0),
        onTap: () => onTap());
  }
}
