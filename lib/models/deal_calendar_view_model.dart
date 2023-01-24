import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/locale.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/screens/deal_calendar/event_deal/event_deal_screen.dart';
import 'package:izowork/views/date_time_wheel_picker_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DealCalendarViewModel with ChangeNotifier {
  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  final DateTime _minDateTime = DateTime(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .year -
          5,
      1,
      1);

  final DateTime _maxDateTime = DateTime(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .year +
          5,
      1,
      1);

  final List<DateTime> _eventDateTimes = [
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1)
        .subtract(const Duration(days: 1)), // TODAY
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 3)
  ];

  DateTime _pickedDateTime =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  DateTime? _selectedDateTime;

  List<DateTime> get eventDateTimes {
    return _eventDateTimes;
  }

  DateTime get pickedDateTime {
    return _pickedDateTime;
  }

  DateTime? get selectedDateTime {
    return _selectedDateTime;
  }

  // MARK: -
  // MARK: - ACTIONS

  void showDateTimeSelectionSheet(BuildContext context, TextStyle textStyle,
      Function(bool) didUpdateDateTime) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        enableDrag: false,
        context: context,
        builder: (context) => DateTimeWheelPickerWidget(
            minDateTime: _minDateTime,
            maxDateTime: _maxDateTime,
            initialDateTime: _pickedDateTime,
            showDays: false,
            locale: locale,
            backgroundColor: HexColors.white,
            buttonColor: HexColors.primaryMain,
            buttonHighlightColor: HexColors.primaryDark,
            buttonTitle: Titles.apply,
            buttonTextStyle: textStyle.copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: HexColors.black),
            selecteTextStyle: textStyle.copyWith(
                fontSize: 14.0,
                color: HexColors.black,
                fontWeight: FontWeight.w400),
            unselectedTextStyle: textStyle.copyWith(
                fontSize: 12.0,
                color: HexColors.grey70,
                fontWeight: FontWeight.w400),
            onTap: (dateTime) => {
                  Navigator.pop(context),

                  // UPDATE PICKED DATE TIME
                  Future.delayed(
                      const Duration(milliseconds: 400),
                      () => {
                            _pickedDateTime = dateTime,
                            notifyListeners(),
                          }).then((value) =>
                      // CALL CALENDAR SCROLL TO PICKED DATE TIME
                      Future.delayed(const Duration(milliseconds: 100),
                          () => didUpdateDateTime(true)))
                }));
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void addDateTime(DateTime dateTime) {
    _eventDateTimes.add(dateTime);
    notifyListeners();
  }

  void selectDateTime(BuildContext context, DateTime dateTime) {
    for (var eventDateTime in _eventDateTimes) {
      if (eventDateTime.year == dateTime.year &&
          eventDateTime.month == dateTime.month &&
          eventDateTime.day == dateTime.day) {
        showCupertinoModalBottomSheet(
            topRadius: const Radius.circular(16.0),
            barrierColor: Colors.black.withOpacity(0.6),
            backgroundColor: HexColors.white,
            context: context,
            builder: (context) => EventDealScreenWidget(dateTime: dateTime));
      }
    }

    _selectedDateTime = dateTime;
    notifyListeners();
  }
}
