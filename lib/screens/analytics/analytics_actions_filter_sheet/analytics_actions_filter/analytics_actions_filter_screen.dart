import 'package:flutter/material.dart';
import 'package:izowork/models/analytics_actions_view_model.dart';
import 'package:izowork/screens/analytics/analytics_actions_filter_sheet/analytics_actions_filter/analytics_actions_filter_screen_body.dart';
import 'package:provider/provider.dart';

class AnalyticsActionsFilterScreenWidget extends StatelessWidget {
  final VoidCallback onManagerTap;
  final VoidCallback onFilialTap;
  final VoidCallback onFromDateTap;
  final VoidCallback onToDateTap;
  final VoidCallback onApplyTap;
  final VoidCallback onResetTap;

  const AnalyticsActionsFilterScreenWidget(
      {Key? key,
      required this.onManagerTap,
      required this.onFilialTap,
      required this.onFromDateTap,
      required this.onToDateTap,
      required this.onApplyTap,
      required this.onResetTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AnalyticsActionsViewModel(),
        child: AnalyticsActionsFilterScreenBodyWidget(
            onManagerTap: onManagerTap,
            onFilialTap: onFilialTap,
            onFromDateTap: onFromDateTap,
            onToDateTap: onToDateTap,
            onApplyTap: onApplyTap,
            onResetTap: onResetTap));
  }
}
