import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/views/subtitle_widget.dart';

class MapObjectStageListItemWidget extends StatelessWidget {
  final int number;
  final String text;

  const MapObjectStageListItemWidget(
      {Key? key, required this.number, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 6.0),
        child: Row(children: [
          Container(
              margin: const EdgeInsets.only(right: 10.0),
              width: 20.0,
              height: 20.0,
              decoration: BoxDecoration(
                  color: HexColors.secondaryMain,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Center(
                  child: Text('$number',
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          color: HexColors.black,
                          fontFamily: 'PT Root UI')))),
          Expanded(child: SubtitleWidget(text: text, padding: EdgeInsets.zero))
        ]));
  }
}
