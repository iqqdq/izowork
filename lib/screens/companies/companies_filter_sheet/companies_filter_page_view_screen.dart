import 'package:flutter/material.dart';
import 'package:izowork/notifiers/domain.dart';
import 'package:izowork/screens/companies/companies_filter_sheet/companies_filter_page_view_screen_body.dart';
import 'package:provider/provider.dart';

class CompaniesFilterPageViewScreenWidget extends StatelessWidget {
  final CompaniesFilter? companiesFilter;
  final Function(CompaniesFilter?) onPop;

  const CompaniesFilterPageViewScreenWidget(
      {Key? key, this.companiesFilter, required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CompaniesFilterViewModel(companiesFilter),
        child: CompaniesFilterPageViewScreenBodyWidget(onPop: onPop));
  }
}
