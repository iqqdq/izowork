import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';

class AnalitycsObjectListItemWidget extends StatelessWidget {
  final double value;
  final VoidCallback onTap;

  const AnalitycsObjectListItemWidget(
      {Key? key, required this.value, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _color = value <= 25.0
        ? HexColors.additionalRed
        : value <= 50.0
            ? HexColors.additionalOrange
            : value <= 75.0
                ? HexColors.additionalDeepBlue
                : HexColors.additionalGreen;

    return Container(
        margin: const EdgeInsets.only(bottom: 10.0, left: 16.0, right: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: HexColors.grey20),
            borderRadius: BorderRadius.circular(16.0)),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                highlightColor: HexColors.grey20,
                splashColor: Colors.transparent,
                borderRadius: BorderRadius.circular(16.0),
                child: Row(children: [
                  /// TITLE
                  Expanded(
                      child: Text('ЖК Жемчужина',
                          style: TextStyle(
                              color: HexColors.grey90,
                              fontSize: 18.0,
                              overflow: TextOverflow.ellipsis,
                              fontFamily: 'PT Root UI'))),
                  const SizedBox(width: 10.0),

                  /// PERCENT
                  Text('${value.toInt()}%',
                      style: TextStyle(
                          color: _color,
                          fontSize: 20.0,
                          fontFamily: 'PT Root UI',
                          fontWeight: FontWeight.bold))
                ]),
                onTap: () => onTap())));
  }
}
