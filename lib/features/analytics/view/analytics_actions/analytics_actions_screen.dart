import 'package:flutter/material.dart';
import 'package:izowork/features/analytics/view_model/analytics_actions_view_model.dart';
import 'package:izowork/features/analytics/view/analytics_actions/analytics_actions_screen_body.dart';
import 'package:provider/provider.dart';

class AnalyticsActionsScreenWidget extends StatelessWidget {
  const AnalyticsActionsScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AnalyticsActionsViewModel(),
        child: const AnalyticsActionsScreenBodyWidget());
  }
}
