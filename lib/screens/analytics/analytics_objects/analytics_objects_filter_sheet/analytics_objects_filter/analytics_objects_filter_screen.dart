import 'package:flutter/material.dart';
import 'package:izowork/models/analytics_objects_filter_view_model.dart';
import 'package:izowork/models/products_filter_view_model.dart';
import 'package:izowork/screens/analytics/analytics_objects/analytics_objects_filter_sheet/analytics_objects_filter/analytics_objects_filter_screen_body.dart';
import 'package:provider/provider.dart';

class AnalyticsObjectsFilterScreenWidget extends StatelessWidget {
  final VoidCallback onTypeTap;
  final VoidCallback onApplyTap;
  final VoidCallback onResetTap;

  const AnalyticsObjectsFilterScreenWidget(
      {Key? key,
      required this.onTypeTap,
      required this.onApplyTap,
      required this.onResetTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AnalyticsObjectsFilterViewModel(),
        child: AnalyticsObjectsFilterScreenBodyWidget(
            onTypeTap: onTypeTap,
            onApplyTap: onApplyTap,
            onResetTap: onResetTap));
  }
}
