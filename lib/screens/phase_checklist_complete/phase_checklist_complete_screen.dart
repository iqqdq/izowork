import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:izowork/entities/response/phase_checklist_information.dart';
import 'package:izowork/models/phase_checklist_complete_view_model.dart';
import 'package:izowork/screens/phase_checklist_complete/phase_checklist_complete_screen_body.dart';
import 'package:provider/provider.dart';

class CompleteChecklistScreenWidget extends StatelessWidget {
  final bool canEdit;
  final String title;
  final PhaseChecklistInfo? phaseChecklistInfo;
  final Function(String, List<PlatformFile>) onTap;

  const CompleteChecklistScreenWidget({
    Key? key,
    required this.canEdit,
    required this.title,
    this.phaseChecklistInfo,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) =>
            PhaseChecklistCompleteViewModel(phaseChecklistInfo),
        child: PhaseChecklistCompleteBodyWidget(
          canEdit: canEdit,
          title: title,
          onTap: onTap,
        ));
  }
}
