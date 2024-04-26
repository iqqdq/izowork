import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/entities/request/phase_checklist_create_request.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/repositories/phase_repository.dart';

class CreateChecklistViewModel with ChangeNotifier {
  final String phaseId;

  LoadingStatus loadingStatus = LoadingStatus.empty;
  String? _error;

  String? get error => _error;

  CreateChecklistViewModel({required this.phaseId});

  Future createPhaseChecklist({required String name}) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await PhaseRepository()
        .createPhaseChecklist(PhaseChecklistCreateRequest(
          phaseId: phaseId,
          name: name,
        ))
        .then((response) => {
              if (response is String)
                loadingStatus = LoadingStatus.completed
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  _error = response.message,
                }
            })
        .then((value) => notifyListeners());
  }
}
