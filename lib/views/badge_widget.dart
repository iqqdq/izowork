import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';

class BadgeWidget extends StatelessWidget {
  final Color? backgroundColor;
  final Color? titleColor;
  final double? radius;
  final int value;

  const BadgeWidget(
      {Key? key,
      this.backgroundColor,
      this.titleColor,
      this.radius,
      required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _radius = radius ?? 7.0;

    return value == 0
        ? Container()
        : CircleAvatar(
            backgroundColor: backgroundColor ?? HexColors.additionalViolet,
            radius: _radius,
            child: Center(
                child: Text(value.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: value.toString().length == 1
                            ? _radius + 3.0
                            : value.toString().length == 2
                                ? _radius + 2.0
                                : _radius,
                        fontWeight: FontWeight.w600,
                        color: titleColor ?? HexColors.white))));
  }
}
