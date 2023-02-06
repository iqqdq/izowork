import 'package:flutter/material.dart';
import 'package:izowork/entities/response/company.dart';
import 'package:izowork/models/company_view_model.dart';
import 'package:izowork/screens/company/company_screen_body.dart';
import 'package:provider/provider.dart';

class CompanyScreenWidget extends StatelessWidget {
  final Company company;

  const CompanyScreenWidget({Key? key, required this.company})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CompanyViewModel(company),
        child: const CompanyScreenBodyWidget());
  }
}
