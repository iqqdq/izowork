import 'package:flutter/material.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/screens/company/company_screen_body.dart';
import 'package:provider/provider.dart';

class CompanyScreenWidget extends StatelessWidget {
  final Company company;
  final Function(Company?)? onPop;

  const CompanyScreenWidget({
    Key? key,
    required this.company,
    required this.onPop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CompanyViewModel(company),
        child: CompanyScreenBodyWidget(onPop: onPop));
  }
}
