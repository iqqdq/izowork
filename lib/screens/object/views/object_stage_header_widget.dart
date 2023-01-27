import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';

class ObjectStageHeaderWidget extends StatelessWidget {
  const ObjectStageHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _textStyle = TextStyle(
        color: HexColors.grey50, fontSize: 12.0, fontFamily: 'PT Root UI');
    return Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 10.0, right: 10.0),
        child: Row(
          children: [
            /// PHASES
            Expanded(
                child: Text(Titles.phases, maxLines: 1, style: _textStyle)),

            /// EFFECTIVENESS
            SizedBox(
                width: 80.0,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(Titles.effectiveness.substring(0, 6) + '.',
                        maxLines: 1,
                        textAlign: TextAlign.right,
                        style: _textStyle))),

            /// READINESS
            SizedBox(
                width: 80.0,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(Titles.readiness,
                        maxLines: 1,
                        textAlign: TextAlign.right,
                        style: _textStyle))),
          ],
        ));
  }
}
