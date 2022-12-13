import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/helpers/string_casing_extension.dart';
import 'package:izowork/views/button_widget.dart';
import 'package:izowork/views/year_month_picker_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

class DealCalendarViewModel with ChangeNotifier {
  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  final List<DateTime> _dateTimes = [
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1)
        .subtract(const Duration(days: 1)), // TODAY
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 3),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 7),
    DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day + 15),
  ];
  DateTime? _selectedDateTime;

  List<DateTime> get dateTimes {
    return _dateTimes;
  }

  DateTime? get selectedDateTime {
    return _selectedDateTime;
  }

  // MARK: -
  // MARK: - ACTIONS

  void showDateTimeSelectionSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.gray,
        context: context,
        builder: (context) => YearMonthPickerWidget(onTap: () => {}));
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void addDateTime(DateTime dateTime) {
    _dateTimes.add(dateTime);
    notifyListeners();
  }

  void selectDateTime(DateTime dateTime) {
    _selectedDateTime = dateTime;
    notifyListeners();
  }
}
