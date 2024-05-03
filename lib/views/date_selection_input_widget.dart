import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/date_time_string_formatter.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/title_widget.dart';

class DateSelectionInputWidget extends StatelessWidget {
  final String title;
  final DateTime? dateTime;
  final VoidCallback onTap;

  const DateSelectionInputWidget({
    Key? key,
    required this.title,
    this.dateTime,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                highlightColor: HexColors.grey10,
                splashColor: Colors.transparent,
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 11.0),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: HexColors.grey20),
                        borderRadius: BorderRadius.circular(16.0)),
                    child: Row(children: [
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            /// TITLE
                            TitleWidget(
                                text: title,
                                isSmall: true,
                                padding: EdgeInsets.zero),

                            /// DATE
                            Text(
                              dateTime == null
                                  ? Titles.notSelected + 'о'
                                  : DateTimeFormatter().formatDateTimeToString(
                                      dateTime: dateTime!,
                                      showTime: false,
                                      showMonthName: false,
                                    ),
                              style: TextStyle(
                                fontSize: 16.0,
                                overflow: TextOverflow.ellipsis,
                                fontFamily: 'PT Root UI',
                                fontWeight: FontWeight.w400,
                                color: HexColors.black,
                              ),
                            )
                          ])),
                      const SizedBox(width: 6.0),
                      SvgPicture.asset('assets/ic_calendar.svg')
                    ])),
                onTap: () => onTap())));
  }
}
