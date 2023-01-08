import 'package:flutter/material.dart';
import 'package:izowork/models/company_view_model.dart';
import 'package:izowork/screens/company/company_screen_body.dart';
import 'package:provider/provider.dart';

class CompanyScreenWidget extends StatelessWidget {
  const CompanyScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CompanyViewModel(),
        child: const CompanyScreenBodyWidget());
  }
}
