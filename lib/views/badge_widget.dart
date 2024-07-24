import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';

class BadgeWidget extends StatelessWidget {
  final int value;
  final Widget? child;

  const BadgeWidget({
    Key? key,
    required this.value,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Badge(
      largeSize: child == null ? 24.0 : 18.0,
      padding: EdgeInsets.symmetric(horizontal: child == null ? 9.0 : 4.0),
      backgroundColor: HexColors.additionalViolet,
      label: Text(
          value.toString().length > 3
              ? value.toString().substring(0, 3) + '...'
              : value.toString(),
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
            color: HexColors.white,
          )),
      isLabelVisible: value > 0,
      child: child,
    );
  }
}
