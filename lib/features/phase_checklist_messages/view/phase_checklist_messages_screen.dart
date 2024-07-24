import 'package:flutter/material.dart';
import 'package:izowork/features/phase_checklist_messages/view_model/phase_checklist_messages_view_model.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/features/phase_checklist_messages/view/phase_checklist_messages_screen_body.dart';
import 'package:provider/provider.dart';

class PhaseChecklistCommentsScreenWidget extends StatelessWidget {
  final PhaseChecklist phaseChecklist;

  const PhaseChecklistCommentsScreenWidget({
    Key? key,
    required this.phaseChecklist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          PhaseChecklistMessagesViewModel(phaseChecklist: phaseChecklist),
      child: const PhaseChecklistMessagesBodyWidget(),
    );
  }
}
