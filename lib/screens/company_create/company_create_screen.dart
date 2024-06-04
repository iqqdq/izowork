import 'package:flutter/material.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/screens/company_create/company_create_screen_body.dart';
import 'package:provider/provider.dart';

class CompanyCreateScreenWidget extends StatelessWidget {
  final Company? company;
  final String? address;
  final double? lat;
  final double? long;
  final Function(Company?)? onPop;

  const CompanyCreateScreenWidget({
    Key? key,
    this.company,
    required this.onPop,
    this.address,
    this.lat,
    this.long,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CompanyCreateViewModel(company),
        child: CompanyCreateScreenBodyWidget(
          address: address,
          lat: lat,
          long: long,
          onPop: onPop,
        ));
  }
}
