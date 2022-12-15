import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/screens/deal_calendar/deal_calendar_screen.dart';

class ActionsViewModel with ChangeNotifier {
  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  // LOCAL
  int _segmentedControlIndex = 0;

  int get segmentedControlIndex {
    return _segmentedControlIndex;
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void changeSegmentedControlIndex(int index) {
    _segmentedControlIndex = index;
    notifyListeners();
  }

  void showDealCalendarScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const DealCalendarScreenWidget()));
  }
}
