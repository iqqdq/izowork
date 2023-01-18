import 'package:flutter/material.dart';
import 'package:izowork/models/analytics_companies_view_model.dart';
import 'package:izowork/screens/analytics/analytics_companies/analytics_companies_screen_body.dart';
import 'package:provider/provider.dart';

class AnalyticsCompaniesScreenWidget extends StatelessWidget {
  const AnalyticsCompaniesScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AnalyticsCompaniesViewModel(),
        child: const AnalyticsCompaniesScreenBodyWidget());
  }
}
