import 'package:flutter/material.dart';
import 'package:izowork/models/deals_filter_view_model.dart';
import 'package:izowork/screens/deals/deals_filter_sheet/deals_filter/deals_filter_screen_body.dart';
import 'package:provider/provider.dart';

class DealsFilterScreenWidget extends StatelessWidget {
  final VoidCallback onResponsibleTap;
  final VoidCallback onObjectTap;
  final VoidCallback onCompanyTap;
  final VoidCallback onApplyTap;
  final VoidCallback onResetTap;

  const DealsFilterScreenWidget(
      {Key? key,
      required this.onResponsibleTap,
      required this.onObjectTap,
      required this.onCompanyTap,
      required this.onApplyTap,
      required this.onResetTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DealsFilterViewModel(),
        child: DealsFilterScreenBodyWidget(
            onResponsibleTap: onResponsibleTap,
            onObjectTap: onObjectTap,
            onCompanyTap: onCompanyTap,
            onApplyTap: onApplyTap,
            onResetTap: onResetTap));
  }
}
