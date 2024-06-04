import 'package:flutter/material.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/screens/analytics/analytics_objects/analytics_objects_screen_body.dart';
import 'package:provider/provider.dart';

class AnalyticsObjectsScreenWidget extends StatelessWidget {
  const AnalyticsObjectsScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ObjectsViewModel(),
        child: const AnalyticsObjectsScreenBodyWidget());
  }
}
