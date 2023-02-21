import 'package:flutter/material.dart';
import 'package:izowork/entities/response/company.dart';
import 'package:izowork/models/company_create_view_model.dart';
import 'package:izowork/screens/company_create/company_create_screen_body.dart';
import 'package:provider/provider.dart';

class CompanyCreateScreenWidget extends StatelessWidget {
  final Company? company;
  final Function(Company) onPop;

  const CompanyCreateScreenWidget({Key? key, this.company, required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CompanyCreateViewModel(company),
        child: CompanyCreateScreenBodyWidget(onPop: onPop));
  }
}
