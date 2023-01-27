import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';

class ObjectStageListItemWidget extends StatelessWidget {
  final VoidCallback onTap;

  const ObjectStageListItemWidget({Key? key, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _textStyle = TextStyle(
        color: HexColors.black, fontSize: 14.0, fontFamily: 'PT Root UI');
    return Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 12.0, right: 10.0),
        child: Row(
          children: [
            /// PHASE
            Expanded(child: Text('Этап', style: _textStyle)),

            /// EFFECTIVENESS
            SizedBox(
                width: 80.0,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text('50%',
                        textAlign: TextAlign.right, style: _textStyle))),

            /// READINESS
            SizedBox(
                width: 80.0,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text('50%',
                        textAlign: TextAlign.right, style: _textStyle))),
          ],
        ));
  }
}
