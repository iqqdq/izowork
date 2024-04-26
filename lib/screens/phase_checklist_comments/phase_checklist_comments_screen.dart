import 'package:flutter/material.dart';
import 'package:izowork/entities/response/phase_checklist.dart';
import 'package:izowork/models/phase_checklist_comments_view_model.dart';
import 'package:izowork/screens/phase_checklist_comments/phase_checklist_comments_screen_body.dart';
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
          PhaseChecklistCommentsViewModel(phaseChecklist: phaseChecklist),
      child: const PhaseChecklistCommentsBodyWidget(),
    );
  }
}
