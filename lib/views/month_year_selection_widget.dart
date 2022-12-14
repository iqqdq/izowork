import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/locale.dart';
import 'package:izowork/components/shadows.dart';
import 'package:izowork/components/titles.dart';
import 'package:intl/intl.dart';
import 'package:izowork/extensions/string_casing_extension.dart';

class MonthYearSelectionWidget extends StatelessWidget {
  final DateTime dateTime;
  final VoidCallback onTap;

  const MonthYearSelectionWidget(
      {Key? key, required this.dateTime, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle _titleTextStyle = TextStyle(
        fontSize: 10.0,
        fontWeight: FontWeight.w500,
        overflow: TextOverflow.ellipsis,
        fontFamily: 'PT Root UI',
        color: HexColors.grey70);

    TextStyle _subtitleTextStyle = TextStyle(
        fontSize: 16.0,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w400,
        fontFamily: 'PT Root UI',
        color: HexColors.black);

    return Container(
        height: 56.0,
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
            color: HexColors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [Shadows.shadow]),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () => onTap(),
                borderRadius: BorderRadius.circular(16.0),
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 11.0),
                    child: Row(children: [
                      /// MONTH
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                            Text(Titles.month, style: _titleTextStyle),
                            Text(
                                DateFormat.MMMM(locale)
                                    .format(dateTime)
                                    .toCapitalized(),
                                style: _subtitleTextStyle)
                          ])),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12.0),
                        width: 1.0,
                        color: HexColors.grey20,
                      ),

                      /// YEAR
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                            Text(Titles.year, style: _titleTextStyle),
                            Text(DateFormat.y().format(dateTime),
                                style: _subtitleTextStyle)
                          ]))
                    ])))));
  }
}
