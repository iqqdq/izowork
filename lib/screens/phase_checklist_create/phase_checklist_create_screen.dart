import 'package:flutter/material.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/screens/phase_checklist_create/phase_checklist_create_screen_body.dart';
import 'package:provider/provider.dart';

class PhaseChecklistCreateScreenWidget extends StatelessWidget {
  final String phaseId;
  final Function(PhaseChecklist? phaseChecklist) onPop;

  const PhaseChecklistCreateScreenWidget({
    Key? key,
    required this.phaseId,
    required this.onPop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => PhaseChecklistCreateViewModel(phaseId: phaseId),
        child: PhaseChecklistCreateBodyWidget(
          phaseId: phaseId,
          onPop: onPop,
        ));
  }
}
