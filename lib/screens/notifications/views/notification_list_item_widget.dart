import 'package:flutter/material.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/views/views.dart';

class NotificationListItemWidget extends StatelessWidget {
  final String text;
  final DateTime dateTime;
  final bool isUnread;
  final VoidCallback onTap;

  const NotificationListItemWidget({
    Key? key,
    required this.text,
    required this.dateTime,
    required this.isUnread,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            width: isUnread ? 1.0 : 0.5,
            color: isUnread ? HexColors.primaryMain : HexColors.grey30,
          ),
        ),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () => onTap(),
                highlightColor: HexColors.grey20,
                splashColor: Colors.transparent,
                borderRadius: BorderRadius.circular(16.0),
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
                              text: DateTimeFormatter().formatDateTimeToString(
                                dateTime: dateTime,
                                showTime: true,
                                showMonthName: true,
                              ),
                              padding: EdgeInsets.zero,
                              isSmall: true,
                            ),

                            /// INDICATOR
                            isUnread
                                ? Container(
                                    width: 9.0,
                                    height: 9.0,
                                    decoration: BoxDecoration(
                                        color: HexColors.primaryMain,
                                        borderRadius:
                                            BorderRadius.circular(4.5)),
                                  )
                                : Container()
                          ]),
                      const SizedBox(height: 6.0),

                      /// TEXT
                      Text(text,
                          style: TextStyle(
                              color: HexColors.black,
                              fontSize: 16.0,
                              fontFamily: 'PT Root UI')),
                    ]))));
  }
}
