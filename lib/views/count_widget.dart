import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';

class CountWidget extends StatelessWidget {
  final int count;

  const CountWidget({Key? key, required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints:
            BoxConstraints(minWidth: count.toString().length > 2 ? 24.0 : 20.0),
        padding: EdgeInsets.symmetric(
            horizontal: count.toString().length > 2 ? 7.0 : 0.0),
        height: 20.0,
        decoration: BoxDecoration(
            color: HexColors.additionalViolet,
            borderRadius: BorderRadius.circular(10.0)),
        child: Center(
            child:

                /// MESSAGE TEXT
                Text('$count',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: HexColors.white,
                        fontSize: 12.0,
                        fontFamily: 'PT Root UI',
                        fontWeight: FontWeight.w500))));
  }
}
