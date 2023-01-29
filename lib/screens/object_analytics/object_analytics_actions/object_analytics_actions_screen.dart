import 'package:flutter/material.dart';
import 'package:izowork/models/object_analytics_actions_view_model.dart';

import 'package:izowork/screens/object_analytics/object_analytics_actions/object_analytics_actions_screen_body.dart';
import 'package:provider/provider.dart';

class ObjectAnalyticsActionsScreenWidget extends StatelessWidget {
  const ObjectAnalyticsActionsScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ObjectAnalyticsActionsViewModel(),
        child: const ObjectAnalyticsActionsScreenBodyWidget());
  }
}
