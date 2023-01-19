import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/extensions/date_time_extension.dart';

class DateHeaderWidget extends StatelessWidget {
  final DateTime dateTime;
  final Widget child;

  const DateHeaderWidget(
      {Key? key, required this.dateTime, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final _yesterday = _today.subtract(const Duration(days: 1));

    final _date = dateTime == _today
        ? 'Сегодня'
        : dateTime == _yesterday
            ? 'Вчера'
            : DateFormat.d().format(dateTime) +
                ' ' +
                DateTimeExtension(dateTime).getMonthName() +
                (dateTime.year != DateTime.now().year
                    ? ', ' + DateFormat.y().format(dateTime)
                    : '');

    return Column(children: [
      IgnorePointer(
          ignoring: true,
          child: Container(
              margin: const EdgeInsets.only(top: 12.0, bottom: 16.0),
              child: Text(_date,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'PT Root UI',
                      fontWeight: FontWeight.w500,
                      color: HexColors.grey40)))),
      child
    ]);
  }
}
