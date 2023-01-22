import 'package:flutter/material.dart';
import 'package:izowork/models/companies_filter_view_model.dart';
import 'package:izowork/screens/companies/companies_filter_sheet/companies_filter/companies_filter_screen_body.dart';
import 'package:provider/provider.dart';

class CompaniesFilterScreenWidget extends StatelessWidget {
  final VoidCallback onManagerTap;
  final VoidCallback onApplyTap;
  final VoidCallback onResetTap;

  const CompaniesFilterScreenWidget(
      {Key? key,
      required this.onManagerTap,
      required this.onApplyTap,
      required this.onResetTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CompaniesFilterViewModel(),
        child: CompaniesFilterScreenBodyWidget(
            onManagerTap: onManagerTap,
            onApplyTap: onApplyTap,
            onResetTap: onResetTap));
  }
}
