import 'package:flutter/material.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/screens/phase_checklist/phase_checklist_screen_body.dart';
import 'package:provider/provider.dart';

class PhaseChecklistScreenWidget extends StatelessWidget {
  final PhaseChecklist phaseChecklist;
  final VoidCallback onInfoCreate;

  const PhaseChecklistScreenWidget({
    Key? key,
    required this.phaseChecklist,
    required this.onInfoCreate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => PhaseChecklistViewModel(phaseChecklist),
        child: PhaseChecklistBodyWidget(onInfoCreate: onInfoCreate));
  }
}
