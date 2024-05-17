import 'package:flutter/material.dart';
import 'package:izowork/notifiers/domain.dart';
import 'package:izowork/screens/analytics/analytics_actions/analytics_actions_filter_sheet/analytics_actions_filter_page_view_screen_body.dart';
import 'package:provider/provider.dart';

class AnalyticsActionsFilterPageViewScreenWidget extends StatelessWidget {
  final AnalyticsActionsFilter? analyticsActionsFilter;
  final Function(AnalyticsActionsFilter?) onPop;

  const AnalyticsActionsFilterPageViewScreenWidget(
      {Key? key, this.analyticsActionsFilter, required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) =>
            AnalyticsActionsFilterViewModel(analyticsActionsFilter),
        child: AnalyticsActionsFilterPageViewScreenBodyWidget(onPop: onPop));
  }
}
