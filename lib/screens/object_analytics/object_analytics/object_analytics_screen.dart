import 'package:flutter/material.dart';
import 'package:izowork/models/object_analytics_view_model.dart';
import 'package:izowork/screens/object_analytics/object_analytics/object_analytics_screen_body.dart';
import 'package:provider/provider.dart';

class ObjectAnalyticsScreenWidget extends StatelessWidget {
  const ObjectAnalyticsScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ObjectAnalyticsViewModel(),
        child: const ObjectAnalyticsScreenBodyWidget());
  }
}
