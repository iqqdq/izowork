import 'package:flutter/material.dart';
import 'package:izowork/features/analytics/view_model/analytics_companies_view_model.dart';

import 'package:izowork/features/analytics/view/analytics_companies/analytics_companies_screen_body.dart';
import 'package:provider/provider.dart';

class AnalyticsCompaniesScreenWidget extends StatelessWidget {
  const AnalyticsCompaniesScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AnalyticsCompaniesViewModel(),
      child: const AnalyticsCompaniesScreenBodyWidget(),
    );
  }
}
