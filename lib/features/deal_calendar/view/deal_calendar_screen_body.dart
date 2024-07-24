import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/features/deal_calendar/view_model/deal_calendar_view_model.dart';
import 'package:izowork/helpers/helpers.dart';
import 'package:izowork/features/deal_event/view/deal_event_screen.dart';
import 'package:izowork/views/views.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
  static const TextStyle _textStyle = TextStyle(
    overflow: TextOverflow.ellipsis,
    fontFamily: 'PT Root UI',
  );

  CleanCalendarController? _cleanCalendarController;

  late DealCalendarViewModel _dealCalendarViewModel;

  @override
  void dispose() {
    _cleanCalendarController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _dealCalendarViewModel = Provider.of<DealCalendarViewModel>(
      context,
      listen: true,
    );

    _cleanCalendarController = CleanCalendarController(
      minDate: DateTime(_dealCalendarViewModel.pickedDateTime.year, 1),
      maxDate: DateTime(_dealCalendarViewModel.pickedDateTime.year, 12),
      initialFocusDate: _dealCalendarViewModel.pickedDateTime,
      onDayTapped: (dateTime) => {
        _dealCalendarViewModel.selectDateTime(dateTime),
        _showDealEventScreenSheet()
      },
    );

    return Scaffold(
      backgroundColor: HexColors.white,
      appBar: AppBar(
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: BackButtonWidget(onTap: () => Navigator.pop(context))),
        title: Text(
          Titles.dealCalendar,
          style: _textStyle.copyWith(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: HexColors.black),
        ),
      ),
      body: SizedBox.expand(
        child: Stack(children: [
          /// CALENDAR
          ScrollableCleanCalendar(
              padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: MediaQuery.of(context).padding.bottom == 0.0
                      ? 80.0
                      : MediaQuery.of(context).padding.bottom + 70.0),
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
                        width: _dealCalendarViewModel.eventDateTimes
                                .contains(values.day)
                            ? 1.0
                            : _dealCalendarViewModel.selectedDateTime == null
                                ? 0.0
                                : isSameDate(
                                        _dealCalendarViewModel
                                            .selectedDateTime!,
                                        values.day)
                                    ? 1.0
                                    : 0.0,
                        color: _dealCalendarViewModel.selectedDateTime == null
                            ? _dealCalendarViewModel.eventDateTimes
                                    .contains(values.day)
                                ? HexColors.grey20
                                : Colors.transparent
                            : isSameDate(
                                    _dealCalendarViewModel.selectedDateTime!,
                                    values.day)
                                ? HexColors.primaryMain
                                : _dealCalendarViewModel.eventDateTimes
                                        .contains(values.day)
                                    ? HexColors.grey20
                                    : Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// EVENT COUNT
                          _dealCalendarViewModel.eventDateTimes
                                  .contains(values.day)
                              ? Container(
                                  width: 18.0,
                                  height: 18.0,
                                  decoration: BoxDecoration(
                                      color: HexColors.primaryMain,
                                      borderRadius: BorderRadius.circular(9.0)),
                                  child: Center(
                                    child: Text(
                                        _dealCalendarViewModel
                                            .getDealCount(values.day)
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        style: _textStyle.copyWith(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w500,
                                          color: HexColors.black,
                                        )),
                                  ),
                                )
                              : const SizedBox(height: 18.0),

                          /// DAY TEXT
                          Text(values.text,
                              style: _textStyle.copyWith(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w400,
                                color: HexColors.black,
                              ))
                        ]),
                  ),
              layout: Layout.BEAUTY),

          /// MONTH / YEAR SELECTION
          Container(
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom == 0.0
                  ? 12.0
                  : MediaQuery.of(context).padding.bottom,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: IgnorePointer(
                ignoring: _dealCalendarViewModel.loadingStatus ==
                    LoadingStatus.searching,
                child: MonthYearSelectionWidget(
                  dateTime: _dealCalendarViewModel.pickedDateTime,
                  onTap: () => _showDateTimeSelectionSheet(),
                ),
              ),
            ),
          ),

          /// INDICATOR
          _dealCalendarViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ]),
      ),
    );
  }

  // MARK: -
  // MARK: - PUSH

  void _showDealEventScreenSheet() {
    if (_dealCalendarViewModel.deals.isEmpty) return;
    if (_dealCalendarViewModel.selectedDateTime == null) return;

    showCupertinoModalBottomSheet(
      enableDrag: false,
      topRadius: const Radius.circular(16.0),
      barrierColor: Colors.black.withOpacity(0.6),
      backgroundColor: HexColors.white,
      context: context,
      builder: (sheetContext) => DealEventScreenWidget(
        dateTime: _dealCalendarViewModel.selectedDateTime!,
        deals: _dealCalendarViewModel.deals,
      ),
    );
  }

  void _showDateTimeSelectionSheet() {
    DateTime? newDateTime;

    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => DateTimeWheelPickerWidget(
            minDateTime: _dealCalendarViewModel.minDateTime,
            maxDateTime: _dealCalendarViewModel.maxDateTime,
            initialDateTime: _dealCalendarViewModel.pickedDateTime,
            showDays: false,
            locale: Platform.localeName,
            backgroundColor: HexColors.white,
            buttonColor: HexColors.primaryMain,
            buttonHighlightColor: HexColors.primaryDark,
            buttonTitle: Titles.apply,
            buttonTextStyle: _textStyle.copyWith(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: HexColors.black,
            ),
            selecteTextStyle: _textStyle.copyWith(
              fontSize: 14.0,
              color: HexColors.black,
              fontWeight: FontWeight.w400,
            ),
            unselectedTextStyle: _textStyle.copyWith(
              fontSize: 12.0,
              color: HexColors.grey70,
              fontWeight: FontWeight.w400,
            ),
            onTap: (dateTime) => {
                  newDateTime = dateTime,
                  Navigator.pop(context),
                })).whenComplete(() {
      _dealCalendarViewModel.changePickedDateTime(newDateTime);
      // CALL CALENDAR SCROLL TO PICKED DATE TIME
      Future.delayed(
          const Duration(milliseconds: 200),
          () => // SCROLL TO MONTH
              _cleanCalendarController?.scrollToMonth(
                date: _dealCalendarViewModel.pickedDateTime,
                duration: const Duration(milliseconds: 200),
                curve: Curves.bounceIn,
              ));
    });
  }
}
