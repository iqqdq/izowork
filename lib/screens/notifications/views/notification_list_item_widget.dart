import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/button_widget_widget.dart';
import 'package:izowork/views/title_widget.dart';

class NotificationListItemWidget extends StatelessWidget {
  final DateTime dateTime;
  final bool isUnread;

  const NotificationListItemWidget(
      {Key? key, required this.dateTime, required this.isUnread})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _minute = dateTime.minute.toString().length == 1
        ? '0${dateTime.minute}'
        : '${dateTime.minute}';
    final _hour = dateTime.hour.toString().length == 1
        ? '0${dateTime.hour}'
        : '${dateTime.hour}';

    final _day = dateTime.day.toString().length == 1
        ? '0${dateTime.day}'
        : '${dateTime.day}';
    final _month = dateTime.month.toString().length == 1
        ? '0${dateTime.month}'
        : '${dateTime.month}';
    final _year = '${dateTime.year}';

    return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
                width: isUnread ? 1.0 : 0.5,
                color: isUnread ? HexColors.primaryMain : HexColors.grey30)),
        child: Material(
            color: Colors.transparent,
            child: ListView(
                padding: const EdgeInsets.all(16.0),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// DATE
                        TitleWidget(
                            text: '$_minute:$_hour, $_day.$_month.$_year',
                            padding: EdgeInsets.zero,
                            isSmall: true),

                        /// INDICATOR
                        isUnread
                            ? Container(
                                width: 9.0,
                                height: 9.0,
                                decoration: BoxDecoration(
                                    color: HexColors.primaryMain,
                                    borderRadius: BorderRadius.circular(4.5)),
                              )
                            : Container()
                      ]),
                  const SizedBox(height: 6.0),

                  /// TEXT
                  Text('Подходит дедлайн по задаче “Название задачи”',
                      style: TextStyle(
                          color: HexColors.black,
                          fontSize: 16.0,
                          fontFamily: 'PT Root UI')),
                ])));
  }
}
