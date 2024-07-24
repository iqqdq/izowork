import 'package:flutter/material.dart';
import 'package:izowork/features/object_analytics/view_model/object_analytics_view_model.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/features/object_analytics/view/object_analytics_screen_body.dart';
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
      child: const ObjectAnalyticsScreenBodyWidget(),
    );
  }
}
