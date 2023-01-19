import 'package:blur/blur.dart';
import 'package:flutter/widgets.dart';
import 'package:izowork/components/hex_colors.dart';

class DismissIndicatorWidget extends StatelessWidget {
  const DismissIndicatorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Blur(
            borderRadius: BorderRadius.circular(4.0),
            child: Container(
                margin: const EdgeInsets.only(bottom: 14.0),
                width: 40.0,
                height: 4.0,
                decoration: BoxDecoration(
                    color: HexColors.grey30,
                    borderRadius: BorderRadius.circular(4.0)))));
  }
}
