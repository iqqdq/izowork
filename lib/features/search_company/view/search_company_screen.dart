import 'package:flutter/material.dart';
import 'package:izowork/features/search_company/view_model/search_company_view_model.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/features/search_company/view/search_company_screen_body.dart';
import 'package:provider/provider.dart';

class SearchCompanyScreenWidget extends StatelessWidget {
  final String title;
  final bool isRoot;
  final VoidCallback onFocus;
  final Function(Company?) onPop;

  const SearchCompanyScreenWidget(
      {Key? key,
      required this.title,
      required this.isRoot,
      required this.onFocus,
      required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SearchCompanyViewModel(),
        child: SearchCompanyScreenBodyWidget(
          title: title,
          isRoot: isRoot,
          onFocus: onFocus,
          onPop: onPop,
        ));
  }
}
