import 'package:flutter/material.dart';
import 'package:izowork/models/analytics_actions_view_model.dart';
import 'package:izowork/screens/analytics/analytics_actions/analytics_actions_filter_sheet/analytics_actions_filter_search/analytics_actions_filter_search_screen_body.dart';
import 'package:provider/provider.dart';

class AnalyticsActionsFilterSearchScreen extends StatelessWidget {
  final bool isFilialSearch;
  final VoidCallback onPop;

  const AnalyticsActionsFilterSearchScreen(
      {Key? key, required this.isFilialSearch, required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AnalyticsActionsViewModel(),
        child: AnalyticsActionsFilterSearchBodyScreen(
            isFilialSearch: isFilialSearch, onPop: onPop));
  }
}
