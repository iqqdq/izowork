// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';

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

  DateTime get minDateTime => _minDateTime;

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

  DateTime get maxDateTime => _maxDateTime;

  DateTime _pickedDateTime = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime get pickedDateTime => _pickedDateTime;

  DateTime? _selectedDateTime;

  DateTime? get selectedDateTime => _selectedDateTime;

  final List<Deal> _deals = [];

  List<Deal> get deals => _deals;

  final List<DateTime> _eventDateTimes = [];

  List<DateTime> get eventDateTimes => _eventDateTimes;

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

  void addDateTime(DateTime dateTime) {
    _eventDateTimes.add(dateTime);
    notifyListeners();
  }

  void selectDateTime(DateTime dateTime) {
    _selectedDateTime = dateTime;

    List<Deal> deals = [];

    _deals.forEach((element) {
      if (dateTime.year == DateTime.parse(element.finishAt).year &&
          dateTime.month == DateTime.parse(element.finishAt).month &&
          dateTime.day == DateTime.parse(element.finishAt).day) {
        deals.add(element);
      }
    });

    notifyListeners();
  }

  void changePickedDateTime(DateTime? dateTime) {
    if (dateTime == null) return;
    _pickedDateTime = dateTime;

    notifyListeners();
  }
}
