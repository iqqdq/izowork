import 'package:flutter/material.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/screens/map_company/map_company_screen_body_widget.dart';

class MapCompanyScreenWidget extends StatelessWidget {
  final Company company;
  final bool? hideInfoButton;

  const MapCompanyScreenWidget({
    Key? key,
    required this.company,
    this.hideInfoButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MapCompanyScreenBodyWidget(
      company: company,
      hideInfoButton: hideInfoButton,
    );
  }
}
