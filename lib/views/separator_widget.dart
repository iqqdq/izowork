import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';

class SeparatorWidget extends StatelessWidget {
  const SeparatorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1.0,
      color: HexColors.grey20,
    );
  }
}
