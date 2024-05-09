import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/entities/requests/requests.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/repositories/repositories.dart';

class PhaseChecklistCreateViewModel with ChangeNotifier {
  final String phaseId;

  LoadingStatus loadingStatus = LoadingStatus.empty;

  PhaseChecklist? _phaseChecklist;

  String? _error;

  PhaseChecklist? get phaseChecklist => _phaseChecklist;

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
