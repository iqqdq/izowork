import 'package:flutter/material.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/notifiers/domain.dart';
import 'package:izowork/screens/object_analytics/object_analytics_screen_body.dart';
import 'package:provider/provider.dart';

class ObjectAnalyticsScreenWidget extends StatelessWidget {
  final MapObject object;
  final List<Phase> phases;

  const ObjectAnalyticsScreenWidget(
      {Key? key, required this.object, required this.phases})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ObjectAnalyticsViewModel(object, phases),
        child: const ObjectAnalyticsScreenBodyWidget());
  }
}
