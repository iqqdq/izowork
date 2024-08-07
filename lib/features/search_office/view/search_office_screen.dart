import 'package:flutter/material.dart';
import 'package:izowork/features/search_office/view_model/search_office_view_model.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/features/search_office/view/search_office_screen_body.dart';
import 'package:provider/provider.dart';

class SearchOfficeScreenWidget extends StatelessWidget {
  final String title;
  final bool isRoot;
  final VoidCallback onFocus;
  final Function(Office?) onPop;

  const SearchOfficeScreenWidget(
      {Key? key,
      required this.title,
      required this.isRoot,
      required this.onFocus,
      required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SearchOfficeViewModel(),
        child: SearchOfficeScreenBodyWidget(
          title: title,
          isRoot: isRoot,
          onFocus: onFocus,
          onPop: onPop,
        ));
  }
}
