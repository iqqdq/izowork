import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/features/task_calendar/view_model/task_calendar_view_model.dart';
import 'package:izowork/helpers/helpers.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/features/task_event/view/task_event_screen.dart';
import 'package:izowork/views/views.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/models/day_values_model.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';

class TaskCalendarScreenBodyWidget extends StatefulWidget {
  const TaskCalendarScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _TaskCalendarScreenBodyState createState() => _TaskCalendarScreenBodyState();
}

class _TaskCalendarScreenBodyState extends State<TaskCalendarScreenBodyWidget> {
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

  DateTime _pickedDateTime = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  final List<DateTime> _eventDateTimes = [];

  DateTime? _selectedDateTime;

  CleanCalendarController? _cleanCalendarController;

  late TaskCalendarViewModel _taskCalendarViewModel;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _taskCalendarViewModel.getTaskList(_pickedDateTime));
  }

  @override
  void dispose() {
    _cleanCalendarController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _taskCalendarViewModel = Provider.of<TaskCalendarViewModel>(
      context,
      listen: true,
    );

    const TextStyle _textStyle = TextStyle(
      overflow: TextOverflow.ellipsis,
      fontFamily: 'PT Root UI',
    );

    // UPDATE CALENDAR
    _cleanCalendarController = CleanCalendarController(
        minDate: DateTime(_pickedDateTime.year, 1),
        maxDate: DateTime(_pickedDateTime.year, 12),
        initialFocusDate: _pickedDateTime,
        onDayTapped: (dateTime) => _selectDateTime(
              context,
              dateTime,
            ));

    // UPDATE CALENDAR EVENT DAYS
    for (var element in _taskCalendarViewModel.tasks) {
      _eventDateTimes.add(DateTime(
        element.deadline.year,
        element.deadline.month,
        element.deadline.day,
      ));
    }

    return Scaffold(
        backgroundColor: HexColors.white,
        appBar: AppBar(
            centerTitle: true,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            leading: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: BackButtonWidget(onTap: () => Navigator.pop(context))),
            title: Text(Titles.taskCalendar,
                style: _textStyle.copyWith(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: HexColors.black))),
        body: SizedBox.expand(
          child: Stack(children: [
            /// CALENDAR
            ScrollableCleanCalendar(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: MediaQuery.of(context).padding.bottom == 0.0
                    ? 80.0
                    : MediaQuery.of(context).padding.bottom + 70.0,
              ),
              calendarController: _cleanCalendarController!,
              locale: Platform.localeName,
              monthTextStyle: _textStyle.copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                color: HexColors.grey40,
              ),
              dayBuilder: (
                BuildContext context,
                DayValues values,
              ) =>
                  Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    width: _eventDateTimes.contains(values.day)
                        ? 1.0
                        : _selectedDateTime == null
                            ? 0.0
                            : isSameDate(
                                _selectedDateTime!,
                                values.day,
                              )
                                ? 1.0
                                : 0.0,
                    color: _selectedDateTime == null
                        ? _eventDateTimes.contains(values.day)
                            ? HexColors.grey20
                            : Colors.transparent
                        : isSameDate(
                            _selectedDateTime!,
                            values.day,
                          )
                            ? HexColors.primaryMain
                            : _eventDateTimes.contains(values.day)
                                ? HexColors.grey20
                                : Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// EVENT COUNT
                      _eventDateTimes.contains(values.day)
                          ? Container(
                              width: 18.0,
                              height: 18.0,
                              decoration: BoxDecoration(
                                color: HexColors.primaryMain,
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              child: Center(
                                  child: Text(
                                _taskCalendarViewModel
                                    .getTaskCount(values.day)
                                    .toString(),
                                textAlign: TextAlign.center,
                                style: _textStyle.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: HexColors.black,
                                ),
                              )),
                            )
                          : const SizedBox(height: 18.0),

                      /// DAY TEXT
                      Text(values.text,
                          style: _textStyle.copyWith(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w400,
                              color: HexColors.black))
                    ]),
              ),
              layout: Layout.BEAUTY,
            ),

            /// MONTH / YEAR SELECTION
            Container(
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom == 0.0
                      ? 12.0
                      : MediaQuery.of(context).padding.bottom),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: IgnorePointer(
                    ignoring: _taskCalendarViewModel.loadingStatus ==
                        LoadingStatus.searching,
                    child: MonthYearSelectionWidget(
                      dateTime: _pickedDateTime,
                      onTap: () => _showDateTimeSelectionSheet(
                        context,
                        _textStyle,
                      ),
                    ),
                  )),
            ),

            /// INDICATOR
            _taskCalendarViewModel.loadingStatus == LoadingStatus.searching
                ? const LoadingIndicatorWidget()
                : Container()
          ]),
        ));
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void _selectDateTime(
    BuildContext context,
    DateTime dateTime,
  ) {
    setState(() => _selectedDateTime = dateTime);

    List<Task> tasks = [];

    for (var element in _taskCalendarViewModel.tasks) {
      if (dateTime.year == element.deadline.year &&
          dateTime.month == element.deadline.month &&
          dateTime.day == element.deadline.day) {
        tasks.add(element);
      }
    }

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

  void _showDateTimeSelectionSheet(
    BuildContext context,
    TextStyle textStyle,
  ) {
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
                        const Duration(milliseconds: 300),
                        () => {
                              setState(() => _pickedDateTime = dateTime),
                            }).then(
                      (value) =>
                          // CALL CALENDAR SCROLL TO PICKED DATE TIME
                          Future.delayed(
                              const Duration(milliseconds: 200),
                              () => _cleanCalendarController?.scrollToMonth(
                                    date: _pickedDateTime,
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.bounceIn,
                                  )),
                    )
                  }
                else
                  {
                    _pickedDateTime = dateTime,
                    _taskCalendarViewModel.getTaskList(_pickedDateTime)
                  }
              }),
    );
  }
}
