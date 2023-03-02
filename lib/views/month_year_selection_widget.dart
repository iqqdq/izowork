import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/locale.dart';
import 'package:izowork/components/titles.dart';
import 'package:intl/intl.dart';
import 'package:izowork/extensions/string_casing_extension.dart';
import 'package:intl/date_symbol_data_local.dart';

class MonthYearSelectionWidget extends StatefulWidget {
  final DateTime dateTime;
  final VoidCallback onTap;

  const MonthYearSelectionWidget(
      {Key? key, required this.dateTime, required this.onTap})
      : super(key: key);

  @override
  _MonthYearSelectionState createState() => _MonthYearSelectionState();
}

class _MonthYearSelectionState extends State<MonthYearSelectionWidget> {
  @override
  void initState() {
    super.initState();

    initializeDateFormatting(locale, null);
  }

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
            border: Border.all(width: 1.0, color: HexColors.grey20)
            // boxShadow: [Shadows.shadow]
            ),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                highlightColor: HexColors.grey20,
                splashColor: Colors.transparent,
                onTap: () => widget.onTap(),
                borderRadius: BorderRadius.circular(16.0),
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
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
                                    .format(widget.dateTime)
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
                            Text(DateFormat.y().format(widget.dateTime),
                                style: _subtitleTextStyle)
                          ]))
                    ])))));
  }
}
