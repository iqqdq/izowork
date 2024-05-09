import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/screens/phase_checklist_complete/phase_checklist_complete_screen_body.dart';
import 'package:provider/provider.dart';

class PhaseChecklistCompleteScreenWidget extends StatelessWidget {
  final String title;
  final PhaseChecklistInfo? phaseChecklistInfo;
  final Function(String, List<PlatformFile>) onTap;

  const PhaseChecklistCompleteScreenWidget({
    Key? key,
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
          title: title,
          onTap: onTap,
        ));
  }
}
