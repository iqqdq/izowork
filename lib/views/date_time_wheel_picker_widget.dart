import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/views/dismiss_indicator_widget.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

class Month {
  final int index;
  final String name;

  Month(this.index, this.name);
}

class DateTimeWheelPickerWidget extends StatefulWidget {
  final DateTime minDateTime;
  final DateTime maxDateTime;
  final DateTime? initialDateTime;
  final bool showDays;
  final bool? hideDismissIndicator;
  final String? locale;
  final Color? backgroundColor;
  final Color? buttonColor;
  final Color? buttonHighlightColor;
  final String? buttonTitle;
  final TextStyle? selecteTextStyle;
  final TextStyle? unselectedTextStyle;
  final TextStyle? buttonTextStyle;
  final Function(DateTime) onTap;

  const DateTimeWheelPickerWidget(
      {Key? key,
      required this.minDateTime,
      required this.maxDateTime,
      this.initialDateTime,
      required this.showDays,
      this.hideDismissIndicator,
      this.locale,
      this.backgroundColor,
      this.buttonColor,
      this.buttonHighlightColor,
      this.buttonTitle,
      this.selecteTextStyle,
      this.unselectedTextStyle,
      this.buttonTextStyle,
      required this.onTap})
      : super(key: key);

  @override
  _DateTimeWheelPickerState createState() => _DateTimeWheelPickerState();
}

class _DateTimeWheelPickerState extends State<DateTimeWheelPickerWidget> {
  final List<Month> _months = [];
  final List<String> _monthNames = [];
  int? _day;
  int? _month;
  int? _year;

  @override
  void initState() {
    super.initState();

    initializeDateFormatting(widget.locale, null);
  }

  // MARK: -
  // MARK: - FUNCTIONS

  List<int> _getDays(int year, int month) {
    int dayCount = DateTime(year, month + 1, 0)
        .toUtc()
        .difference(DateTime(year, month, 0).toUtc())
        .inDays;

    List<int> days = [];

    for (var day = 1; day <= dayCount; day++) {
      days.add(day);

      if (day == dayCount) {
        break;
      }
    }

    return days;
  }

  List<String> _getMonthNames(String locale, int year) {
    _months.clear();
    _monthNames.clear();

    for (var i = 1; i <= 12; i++) {
      Month month = Month(
          i, toCapitalized(DateFormat.MMMM(locale).format(DateTime(year, i))));

      _months.add(month);
      _monthNames.add(month.name);
    }

    return _monthNames;
  }

  List<int> _getYears() {
    List<int> years = [];

    for (var year = widget.minDateTime.year;
        year < widget.maxDateTime.year;
        year++) {
      years.add(year);

      if (year == widget.maxDateTime.year) {
        break;
      }
    }

    return years;
  }

  Widget _wheel(List<dynamic> data, int? startPosition, String? locale,
      Function(dynamic) onValueChanged) {
    int position = startPosition == null
        ? 0
        : startPosition == 0
            ? startPosition
            : startPosition - 1;

    return SizedBox(
        width: double.infinity,
        height: 191.0,
        child: WheelChooser(
            isInfinite: false,
            perspective: 0.005,
            itemSize: 36.0,
            startPosition: position,
            selectTextStyle: widget.selecteTextStyle ??
                const TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
            unSelectTextStyle: widget.unselectedTextStyle ??
                const TextStyle(
                    color: Colors.black54,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400),
            onValueChanged: (value) => onValueChanged(value),
            datas: data));
  }

  String toCapitalized(String text) => text.isNotEmpty
      ? '${text[0].toUpperCase()}${text.substring(1).toLowerCase()}'
      : '';

  bool isSameDate(DateTime dateTime, DateTime calendarDateTime) {
    return dateTime.year == calendarDateTime.year &&
        dateTime.month == calendarDateTime.month &&
        dateTime.day == calendarDateTime.day;
  }

  @override
  Widget build(BuildContext context) {
    final margin =
        widget.showDays ? 0.0 : MediaQuery.of(context).size.width / 8.0;

    String? locale = widget.locale ?? 'en';
    Color? backgroundColor = widget.backgroundColor ?? Colors.white;
    Color? buttonColor = widget.buttonColor ?? Colors.blue;
    Color? buttonHighlightColor = widget.buttonHighlightColor ?? Colors.black54;
    String? buttonTitle = widget.buttonTitle ?? 'Select';

    bool isInitialDateTime = widget.initialDateTime == null
        ? false
        : isSameDate(widget.initialDateTime!, widget.minDateTime) ||
                widget.initialDateTime!.isAfter(widget.minDateTime) &&
                    isSameDate(widget.initialDateTime!, widget.maxDateTime) ||
                widget.initialDateTime!.isBefore(widget.maxDateTime)
            ? true
            : false;

    List<int> years = _getYears();

    _day ??= widget.initialDateTime?.day ?? 0;
    _month ??= widget.initialDateTime?.month ?? 0;

    int index = 0;

    for (var year in years) {
      if (year == widget.initialDateTime!.year) {
        break;
      } else {
        index++;
      }
    }

    _year ??= years[index < years.length ? index : years.length - 1];

    List<int> days = _getDays(_year ?? 0, _month ?? 0);
    List<String> months = _getMonthNames(locale, _year ?? 0);

    final _hideDismissIndicator = widget.hideDismissIndicator == null
        ? false
        : widget.hideDismissIndicator == false
            ? false
            : true;

    return Material(
        type: MaterialType.transparency,
        child: Container(
            color: backgroundColor,
            child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 8.0),
                children: [
                  /// DISMISS INDICATOR
                  _hideDismissIndicator
                      ? Container()
                      : const DismissIndicatorWidget(),
                  Container(
                      margin: EdgeInsets.only(
                          top: 18.0, left: margin, right: margin),
                      height: 191.0,
                      child: Stack(children: [
                        Center(
                            child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          width: double.infinity,
                          height: 32.0,
                          color: HexColors.grey10,
                        )),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              /// DAYS
                              widget.showDays
                                  ? Expanded(
                                      child: _wheel(
                                          days,
                                          isInitialDateTime ? _day : 0,
                                          locale,
                                          (value) =>
                                              setState((() => _day = value))))
                                  : Container(),

                              /// MONTHS
                              Expanded(
                                  child: _wheel(
                                      months,
                                      isInitialDateTime ? _month : 0,
                                      locale,
                                      (value) => setState((() {
                                            for (var month in _months) {
                                              if (month.name == value) {
                                                _month = month.index;
                                              }
                                            }
                                          })))),

                              /// YEARS
                              Expanded(
                                  child: _wheel(
                                      years,
                                      isInitialDateTime ? index + 1 : 0,
                                      locale,
                                      (value) =>
                                          setState((() => _year = value))))
                            ])
                      ])),

                  /// BUTTON
                  Container(
                      margin: EdgeInsets.only(
                          top: 24.0,
                          left: 16.0,
                          right: 16.0,
                          bottom: MediaQuery.of(context).padding.bottom == 0.0
                              ? 12.0
                              : MediaQuery.of(context).padding.bottom),
                      height: 54.0,
                      decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(16.0)),
                      child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                              highlightColor: buttonHighlightColor,
                              borderRadius: BorderRadius.circular(16.0),
                              child: Center(
                                  child: Text(buttonTitle,
                                      textAlign: TextAlign.center,
                                      style: widget.buttonTextStyle ??
                                          const TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white))),
                              onTap: () => widget
                                  .onTap(DateTime(_year!, _month!, _day!)))))
                ])));
  }
}
