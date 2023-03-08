import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:izowork/entities/response/phase_checklist_information.dart';
import 'package:izowork/models/complete_checklist_view_model.dart';
import 'package:izowork/screens/complete_checklist/complete_checklist_screen_body.dart';
import 'package:provider/provider.dart';

class CompleteChecklistScreenWidget extends StatelessWidget {
  final String title;
  final PhaseChecklistInformation? phaseChecklistInformation;
  final Function(String, List<PlatformFile>) onTap;

  const CompleteChecklistScreenWidget(
      {Key? key,
      required this.title,
      this.phaseChecklistInformation,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) =>
            CompleteChecklistViewModel(phaseChecklistInformation),
        child: CompleteChecklistBodyWidget(title: title, onTap: onTap));
  }
}
