import 'package:flutter/material.dart';
import 'package:izowork/entities/response/phase.dart';
import 'package:izowork/models/object_analytics_view_model.dart';
import 'package:izowork/screens/object_analytics/object_analytics_screen_body.dart';
import 'package:provider/provider.dart';
import 'package:izowork/entities/response/object.dart';

class ObjectAnalyticsScreenWidget extends StatelessWidget {
  final Object object;
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
