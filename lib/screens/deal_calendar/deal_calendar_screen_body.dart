import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/locale.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/helpers/same_date_time_checker.dart';
import 'package:izowork/models/deal_calendar_view_model.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/month_year_selection_widget.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/models/day_values_model.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';

class DealCalendarScreenBodyWidget extends StatefulWidget {
  const DealCalendarScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _DealCalendarScreenBodyState createState() => _DealCalendarScreenBodyState();
}

class _DealCalendarScreenBodyState extends State<DealCalendarScreenBodyWidget> {
  late DealCalendarViewModel _dealCalendarViewModel;
  CleanCalendarController? _cleanCalendarController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _cleanCalendarController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle _textStyle =
        TextStyle(overflow: TextOverflow.ellipsis, fontFamily: 'PT Root UI');
    _dealCalendarViewModel =
        Provider.of<DealCalendarViewModel>(context, listen: true);

    _cleanCalendarController = CleanCalendarController(
        minDate: DateTime(_dealCalendarViewModel.pickedDateTime.year, 1),
        maxDate: DateTime(_dealCalendarViewModel.pickedDateTime.year, 12),
        initialFocusDate: _dealCalendarViewModel.pickedDateTime,
        onAfterMaxDateTapped: (dateTime) =>
            _dealCalendarViewModel.selectDateTime(dateTime),
        onDayTapped: (dateTime) =>
            _dealCalendarViewModel.selectDateTime(dateTime));

    return Scaffold(
        backgroundColor: HexColors.white,
        appBar: AppBar(
            centerTitle: true,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            leading: Padding(
                padding: EdgeInsets.only(left: Platform.isAndroid ? 16.0 : 0.0),
                child: BackButtonWidget(onTap: () => Navigator.pop(context))),
            title: Text(Titles.dealCalendar,
                style: _textStyle.copyWith(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: HexColors.black))),
        body: SizedBox.expand(
            child: Stack(children: [
          Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom == 0.0
                      ? 56.0
                      : MediaQuery.of(context).padding.bottom + 56.0),
              child:

                  /// CALENDAR
                  ScrollableCleanCalendar(
                      calendarController: _cleanCalendarController!,
                      locale: locale,
                      monthTextStyle: _textStyle.copyWith(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: HexColors.grey40),
                      dayBuilder: (BuildContext context, DayValues values) =>
                          Container(
                            // margin: const EdgeInsets.only(
                            //     bottom: 4.0, left: 2.0, right: 2.0),
                            decoration: BoxDecoration(
                              color: _dealCalendarViewModel.eventDateTimes
                                      .contains(values.day)
                                  ? HexColors.grey10
                                  : Colors.transparent,
                              border: Border.all(
                                  width:
                                      _dealCalendarViewModel.selectedDateTime ==
                                              null
                                          ? 0.0
                                          : isSameDate(
                                                  _dealCalendarViewModel
                                                      .selectedDateTime!,
                                                  values.day)
                                              ? 1.0
                                              : 0.0,
                                  color:
                                      _dealCalendarViewModel.selectedDateTime ==
                                              null
                                          ? Colors.transparent
                                          : isSameDate(
                                                  _dealCalendarViewModel
                                                      .selectedDateTime!,
                                                  values.day)
                                              ? HexColors.primaryMain
                                              : Colors.transparent),
                              borderRadius: BorderRadius.circular(6.0),
                              // boxShadow: _dealCalendarViewModel.eventDateTimes
                              //         .contains(values.day)
                              //     ? [Shadows.calendarEventShadow]
                              //     : []
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  /// EVENT COUNT
                                  _dealCalendarViewModel.eventDateTimes
                                          .contains(values.day)
                                      ? Container(
                                          // margin:
                                          //     const EdgeInsets.only(top: 2.0),
                                          width: 18.0,
                                          height: 18.0,
                                          decoration: BoxDecoration(
                                              color: HexColors.primaryMain,
                                              borderRadius:
                                                  BorderRadius.circular(9.0)),
                                          child: Center(
                                              child: Text('1',
                                                  textAlign: TextAlign.center,
                                                  style: _textStyle.copyWith(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: HexColors.black))),
                                        )
                                      : Container(
                                          // margin:
                                          //     const EdgeInsets.only(top: 2.0),
                                          height: 18.0),

                                  /// DAY TEXT
                                  Text(values.text,
                                      style: _textStyle.copyWith(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w400,
                                          color: HexColors.black))
                                ]),
                          ),
                      layout: Layout.BEAUTY)),

          /// MONTH / YEAR SELECTION
          Container(
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom == 0.0
                      ? 12.0
                      : MediaQuery.of(context).padding.bottom),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: MonthYearSelectionWidget(
                      dateTime: _dealCalendarViewModel.pickedDateTime,
                      onTap: () =>
                          _dealCalendarViewModel.showDateTimeSelectionSheet(
                              context,
                              _textStyle,
                              (dateTimeDidUpdate) => {
                                    // // SCROLL TO MONTH
                                    if (dateTimeDidUpdate)
                                      _cleanCalendarController?.scrollToMonth(
                                          date: _dealCalendarViewModel
                                              .pickedDateTime,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.bounceIn)
                                  })))),

          /// INDICATOR
          _dealCalendarViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
