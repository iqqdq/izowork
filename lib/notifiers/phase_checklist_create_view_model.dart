import 'package:flutter/material.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';

class PhaseChecklistCreateViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.empty;

  final String phaseId;

  PhaseChecklist? _phaseChecklist;

  PhaseChecklist? get phaseChecklist => _phaseChecklist;

  String? _error;

  String? get error => _error;

  PhaseChecklistCreateViewModel({required this.phaseId});

  Future createPhaseChecklist({required String name}) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await PhaseRepository()
        .createPhaseChecklist(PhaseChecklistRequest(
          phaseId: phaseId,
          name: name,
        ))
        .then((response) => {
              if (response is PhaseChecklist)
                {
                  loadingStatus = LoadingStatus.completed,
                  _phaseChecklist = response,
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  _error = response.message,
                }
            })
        .whenComplete(() => notifyListeners());
  }
}
