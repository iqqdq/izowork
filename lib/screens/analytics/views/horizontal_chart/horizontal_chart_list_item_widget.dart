import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/locale.dart';

class HorizontalChartListItemWidget extends StatelessWidget {
  final int index;
  final double maxHeight;
  final double height;
  final double value;
  final DateTime dateTime;

  const HorizontalChartListItemWidget({
    Key? key,
    required this.index,
    required this.maxHeight,
    required this.height,
    required this.value,
    required this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting(locale, null);

    final _day = DateTime.now().day.toString().length == 1
        ? '0${DateTime.now().day}'
        : '${DateTime.now().day}';
    final _month = DateFormat.MMM(locale).format(DateTime.now());

    return SizedBox(
        width: 60.0,
        child: Stack(children: [
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Container(
                width: 48.0, height: height, color: HexColors.primaryMain),
            Container(
                padding: const EdgeInsets.only(top: 6.0, left: 2.0, right: 2.0),
                child: Text('$_month $_day',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: HexColors.grey40,
                        fontSize: 12.0,
                        fontFamily: 'PT Root UI')))
          ]),
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Container(
                padding: const EdgeInsets.only(bottom: 20.0),
                width: 60.0,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Text(value.toInt().toString(),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: HexColors.black,
                                  fontSize: 14.0,
                                  fontFamily: 'PT Root UI',
                                  fontWeight: FontWeight.w500))),
                      Container(height: 1.0, color: HexColors.grey20)
                    ]))
          ])
        ]));
  }
}