import 'package:flutter/material.dart';
import 'package:izowork/models/companies_search_view_model.dart';
import 'package:izowork/screens/companies/companies_filter_sheet/companies_filter_search/companies_filter_search_screen_body.dart';
import 'package:provider/provider.dart';

class CompaniesFilterSearchScreenWidget extends StatelessWidget {
  final VoidCallback onPop;

  const CompaniesFilterSearchScreenWidget({Key? key, required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CompaniesSearchViewModel(),
        child: CompaniesFilterSearchBodyScreenWidget(onPop: onPop));
  }
}
