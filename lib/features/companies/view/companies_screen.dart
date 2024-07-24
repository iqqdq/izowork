import 'package:flutter/material.dart';
import 'package:izowork/features/companies/view_model/companies_view_model.dart';
import 'package:izowork/features/companies/view/companies_screen_body.dart';
import 'package:provider/provider.dart';

class CompaniesScreenWidget extends StatelessWidget {
  const CompaniesScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CompaniesViewModel(),
      child: const CompaniesScreenBodyWidget(),
    );
  }
}
