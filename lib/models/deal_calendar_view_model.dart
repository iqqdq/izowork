// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/screens/deal_event/deal_event_screen.dart';
import 'package:izowork/views/views.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DealCalendarViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final DateTime _minDateTime = DateTime(
    DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        ).year -
        5,
    1,
    1,
  );

  final DateTime _maxDateTime = DateTime(
    DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        ).year +
        5,
    1,
    1,
  );

  final List<DateTime> _eventDateTimes = [];

  DateTime _pickedDateTime = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime? _selectedDateTime;

  final List<Deal> _deals = [];

  List<DateTime> get eventDateTimes => _eventDateTimes;

  DateTime get pickedDateTime => _pickedDateTime;

  DateTime? get selectedDateTime => _selectedDateTime;

  List<Deal> get deals => _deals;

  DealCalendarViewModel() {
    getDealList(_pickedDateTime);
  }

  // MARK: -
  // MARK: - API CALL

  Future getDealList(DateTime dateTime) async {
    loadingStatus = LoadingStatus.searching;
    _deals.clear();

    Future.delayed(Duration.zero, () async {
      notifyListeners();
    });

    await DealRepository()
        .getYearDeals(params: [
          "deadline=gte:${_pickedDateTime.year}-01-01T00:00:00Z&deadline=lte:${_pickedDateTime.year}-12-31T00:00:00Z"
        ])
        .then((response) => {
              if (response is List<Deal>)
                {
                  if (_deals.isEmpty)
                    {
                      response.forEach((deal) {
                        _deals.add(deal);
                      })
                    }
                  else
                    {
                      response.forEach((newDeal) {
                        bool found = false;

                        _deals.forEach((deal) {
                          if (newDeal.id == deal.id) {
                            found = true;
                          }
                        });

                        if (!found) {
                          _deals.add(newDeal);
                        }
                      })
                    },
                  loadingStatus = LoadingStatus.completed,
                }
              else
                loadingStatus = LoadingStatus.error
            })
        .whenComplete(() => {
              // UPDATE CALENDART EVENT DAYS
              if (_deals.isNotEmpty)
                _deals.forEach((element) {
                  _eventDateTimes.add(DateTime(
                    DateTime.parse(element.finishAt).year,
                    DateTime.parse(element.finishAt).month,
                    DateTime.parse(element.finishAt).day,
                  ));
                }),
              notifyListeners()
            });
  }

  // MARK: -
  // MARK: - FUNCTIONS

  int getDealCount(DateTime dateTime) {
    int count = 0;

    _deals.forEach((element) {
      if (dateTime.year == DateTime.parse(element.finishAt).year &&
          dateTime.month == DateTime.parse(element.finishAt).month &&
          dateTime.day == DateTime.parse(element.finishAt).day) {
        count++;
      }
    });

    return count;
  }

  // MARK: -
  // MARK: - ACTIONS

  void showDateTimeSelectionSheet(
    BuildContext context,
    TextStyle textStyle,
    Function(bool) didUpdateDateTime,
  ) =>
      showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => DateTimeWheelPickerWidget(
            minDateTime: _minDateTime,
            maxDateTime: _maxDateTime,
            initialDateTime: _pickedDateTime,
            showDays: false,
            locale: Platform.localeName,
            backgroundColor: HexColors.white,
            buttonColor: HexColors.primaryMain,
            buttonHighlightColor: HexColors.primaryDark,
            buttonTitle: Titles.apply,
            buttonTextStyle: textStyle.copyWith(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: HexColors.black,
            ),
            selecteTextStyle: textStyle.copyWith(
              fontSize: 14.0,
              color: HexColors.black,
              fontWeight: FontWeight.w400,
            ),
            unselectedTextStyle: textStyle.copyWith(
              fontSize: 12.0,
              color: HexColors.grey70,
              fontWeight: FontWeight.w400,
            ),
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
                }),
      );

  // MARK: -
  // MARK: - FUNCTIONS

  void addDateTime(DateTime dateTime) {
    _eventDateTimes.add(dateTime);
    notifyListeners();
  }

  void selectDateTime(
    BuildContext context,
    DateTime dateTime,
  ) {
    _selectedDateTime = dateTime;
    notifyListeners();

    List<Deal> deals = [];

    _deals.forEach((element) {
      if (dateTime.year == DateTime.parse(element.finishAt).year &&
          dateTime.month == DateTime.parse(element.finishAt).month &&
          dateTime.day == DateTime.parse(element.finishAt).day) {
        deals.add(element);
      }
    });

    if (deals.isNotEmpty) {
      showCupertinoModalBottomSheet(
          enableDrag: false,
          topRadius: const Radius.circular(16.0),
          barrierColor: Colors.black.withOpacity(0.6),
          backgroundColor: HexColors.white,
          context: context,
          builder: (sheetContext) =>
              DealEventScreenWidget(dateTime: dateTime, deals: deals));
    }
  }
}
