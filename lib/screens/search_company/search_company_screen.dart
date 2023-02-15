import 'package:flutter/material.dart';
import 'package:izowork/entities/response/company.dart';
import 'package:izowork/models/search_company_view_model.dart';
import 'package:izowork/screens/search_company/search_company_screen_body.dart';
import 'package:provider/provider.dart';

class SearchCompanyScreenWidget extends StatelessWidget {
  final bool isRoot;
  final VoidCallback onFocus;
  final Function(Company?) onPop;

  const SearchCompanyScreenWidget(
      {Key? key,
      required this.isRoot,
      required this.onFocus,
      required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SearchCompanyViewModel(),
        child: SearchCompanyScreenBodyWidget(
            isRoot: isRoot, onFocus: onFocus, onPop: onPop));
  }
}
