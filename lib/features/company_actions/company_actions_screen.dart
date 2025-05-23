import 'package:flutter/material.dart';
import 'package:izowork/features/company_actions/view_model/company_actions_view_model.dart';

import 'package:provider/provider.dart';
import 'package:izowork/features/company_actions/company_actions_screen_body.dart';

class CompanyActionsScreenWidget extends StatelessWidget {
  final String id;

  const CompanyActionsScreenWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CompanyActionsViewModel(id),
      child: CompanyActionsScreenBodyWidget(id: id),
    );
  }
}
