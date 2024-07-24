import 'package:flutter/material.dart';
import 'package:izowork/features/company/view_model/company_page_view_model.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/features/company/view/company_page/company_page_screen_body.dart';
import 'package:provider/provider.dart';

class CompanyPageScreenWidget extends StatelessWidget {
  final String id;
  final Function(Company?) onPop;

  const CompanyPageScreenWidget({
    Key? key,
    required this.id,
    required this.onPop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CompanyPageViewModel(id),
      child: CompanyPageScreenBodyWidget(
        id: id,
        onPop: onPop,
      ),
    );
  }
}
