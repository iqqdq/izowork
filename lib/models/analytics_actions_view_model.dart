import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/screens/analytics/analytics_actions/analytics_actions_filter_sheet/analytics_actions_filter_page_view_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AnalyticsActionsViewModel with ChangeNotifier {
  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  // MARK: -
  // MARK: - PUSH

  void showAnalyticsActionFilterSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => AnalyticsActionsFilterPageViewWidget(
            onApplyTap: () => {Navigator.pop(context)},
            onResetTap: () => {Navigator.pop(context)}));
  }

  // MARK: -
  // MARK: - FUNCTIONS
}
