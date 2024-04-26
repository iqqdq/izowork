import 'package:flutter/material.dart';
import 'package:izowork/models/create_checklist_view_model.dart';
import 'package:izowork/screens/create_checklist/create_checklist_screen_body.dart';
import 'package:provider/provider.dart';

class CreateChecklistScreenWidget extends StatelessWidget {
  final String phaseId;
  final VoidCallback onPop;

  const CreateChecklistScreenWidget({
    Key? key,
    required this.phaseId,
    required this.onPop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CreateChecklistViewModel(phaseId: phaseId),
        child: CreateChecklistBodyWidget(
          phaseId: phaseId,
          onPop: onPop,
        ));
  }
}
