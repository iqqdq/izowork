// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/locale.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/task.dart';
import 'package:izowork/repositories/task_repository.dart';
import 'package:izowork/screens/task_event/task_event_screen.dart';
import 'package:izowork/views/date_time_wheel_picker_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TaskCalendarViewModel with ChangeNotifier {
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

  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<Task> _tasks = [];

  List<DateTime> get eventDateTimes => _eventDateTimes;

  DateTime get pickedDateTime => _pickedDateTime;

  DateTime? get selectedDateTime => _selectedDateTime;

  List<Task> get tasks => _tasks;

  TaskCalendarViewModel() {
    getTaskList(_pickedDateTime);
  }

  // MARK: -
  // MARK: - API CALL

  Future getTaskList(DateTime dateTime) async {
    loadingStatus = LoadingStatus.searching;
    _tasks.clear();

    Future.delayed(Duration.zero, () async {
      notifyListeners();
    });

    await TaskRepository()
        .getYearTasks(params: [
          "deadline=gte:${_pickedDateTime.year}-01-01T00:00:00Z&deadline=lte:${_pickedDateTime.year}-12-31T00:00:00Z"
        ])
        .then((response) => {
              if (response is List<Task>)
                {
                  if (_tasks.isEmpty)
                    {
                      response.forEach((task) {
                        _tasks.add(task);
                      })
                    }
                  else
                    {
                      response.forEach((newTask) {
                        bool found = false;

                        _tasks.forEach((task) {
                          if (newTask.id == task.id) {
                            found = true;
                          }
                        });

                        if (!found) {
                          _tasks.add(newTask);
                        }
                      })
                    },

                  // UPDATE CALENDART EVENT DAYS
                  _tasks.forEach((element) {
                    _eventDateTimes.add(DateTime(
                      DateTime.parse(element.deadline).year,
                      DateTime.parse(element.deadline).month,
                      DateTime.parse(element.deadline).day,
                    ));
                  }),

                  loadingStatus = LoadingStatus.completed,
                }
              else
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => notifyListeners());
  }

  // MARK: -
  // MARK: - ACTIONS

  void showDateTimeSelectionSheet(BuildContext context, TextStyle textStyle,
      Function(bool) didUpdateDateTime) {
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
                  if (_pickedDateTime.year == dateTime.year)
                    {
                      // UPDATE PICKED DATE TIME
                      Future.delayed(
                          const Duration(milliseconds: 400),
                          () => {
                                _pickedDateTime = dateTime,
                                notifyListeners(),
                              }).then(
                        (value) =>
                            // CALL CALENDAR SCROLL TO PICKED DATE TIME
                            Future.delayed(const Duration(milliseconds: 100),
                                () => didUpdateDateTime(true)),
                      )
                    }
                  else
                    {
                      _tasks.clear(),
                      _pickedDateTime = dateTime,
                      getTaskList(_pickedDateTime)
                    }
                }));
  }

  // MARK: -
  // MARK: - FUNCTIONS

  int getTaskCount(DateTime dateTime) {
    int count = 0;

    _tasks.forEach((element) {
      if (dateTime.year == DateTime.parse(element.deadline).year &&
          dateTime.month == DateTime.parse(element.deadline).month &&
          dateTime.day == DateTime.parse(element.deadline).day) {
        count++;
      }
    });

    return count;
  }

  // MARK: -
  // MARK: - ACTIONS

  void selectDateTime(BuildContext context, DateTime dateTime) {
    _selectedDateTime = dateTime;
    notifyListeners();

    List<Task> tasks = [];

    _tasks.forEach((element) {
      if (dateTime.year == DateTime.parse(element.deadline).year &&
          dateTime.month == DateTime.parse(element.deadline).month &&
          dateTime.day == DateTime.parse(element.deadline).day) {
        tasks.add(element);
      }
    });

    if (tasks.isNotEmpty) {
      showCupertinoModalBottomSheet(
          enableDrag: false,
          topRadius: const Radius.circular(16.0),
          barrierColor: Colors.black.withOpacity(0.6),
          backgroundColor: HexColors.white,
          context: context,
          builder: (sheetContext) => TaskEventScreenWidget(
                dateTime: dateTime,
                tasks: tasks,
              ));
    }
  }
}
