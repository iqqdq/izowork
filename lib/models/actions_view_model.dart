import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/entities/response/deal.dart';
import 'package:izowork/entities/response/task.dart';
import 'package:izowork/screens/actions/deals_filter_sheet/deals_filter_page_view_widget.dart';
import 'package:izowork/screens/actions/tasks_filter_sheet%20/tasks_filter_page_view_widget.dart';
import 'package:izowork/screens/deal/deal_screen.dart';
import 'package:izowork/screens/deal_calendar/deal_calendar_screen.dart';
import 'package:izowork/screens/deal_create/deal_create_screen.dart';
import 'package:izowork/screens/task/task_screen.dart';
import 'package:izowork/screens/task_create/task_create_screen.dart';
import 'package:izowork/screens/task_calendar/task_calendar_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ActionsViewModel with ChangeNotifier {
  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  // LOCAL
  int _segmentedControlIndex = 0;

  int get segmentedControlIndex {
    return _segmentedControlIndex;
  }

  // MARK: -
  // MARK: - PUSH

  void showCalendarScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => _segmentedControlIndex == 0
                ? const DealCalendarScreenWidget()
                : const TaskCalendarScreenWidget()));
  }

  void showDealCreateScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const DealCreateScreenWidget()));
  }

  void showTaskCreateScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const TaskCreateScreenWidget()));
  }

  void showDealsFilterSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => DealsFilterPageViewWidget(
            onApplyTap: () => {Navigator.pop(context)},
            onResetTap: () => {Navigator.pop(context)}));
  }

  void showTasksFilterSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => TasksFilterPageViewWidget(
            onApplyTap: () => {Navigator.pop(context)},
            onResetTap: () => {Navigator.pop(context)}));
  }

  void showDealScreenWidget(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DealScreenWidget(deal: Deal())));
  }

  void showTaskScreenWidget(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TaskScreenWidget(task: Task())));
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void changeSegmentedControlIndex(int index) {
    _segmentedControlIndex = index;
    notifyListeners();
  }
}
