import 'package:flutter/material.dart';
import 'package:izowork/notifiers/domain.dart';
import 'package:izowork/screens/analytics/analytics_actions/analytics_actions_screen_body.dart';
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
