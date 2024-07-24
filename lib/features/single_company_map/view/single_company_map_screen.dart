import 'package:flutter/material.dart';
import 'package:izowork/features/single_company_map/view_model/single_company_map_view_model.dart';

import 'package:izowork/features/single_company_map/view/single_company_map_screen_body.dart';
import 'package:provider/provider.dart';
import 'package:izowork/models/models.dart';

class SingleCompanyMapScreenWidget extends StatelessWidget {
  final Company company;

  const SingleCompanyMapScreenWidget({
    Key? key,
    required this.company,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SingleCompanyMapViewModel(company),
      child: const SingleCompanyMapScreenBodyWidget(),
    );
  }
}
