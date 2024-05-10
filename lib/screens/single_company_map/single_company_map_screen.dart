import 'package:flutter/material.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/screens/single_company_map/single_company_map_screen_body.dart';
import 'package:provider/provider.dart';
import 'package:izowork/entities/responses/responses.dart';

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
