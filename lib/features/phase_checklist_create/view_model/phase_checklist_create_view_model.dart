import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/repositories/repositories.dart';

class PhaseChecklistCreateViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.empty;

  final String phaseId;

  PhaseChecklist? _phaseChecklist;

  PhaseChecklist? get phaseChecklist => _phaseChecklist;

  final DateTime _minDateTime = DateTime.now();

  DateTime get minDateTime => _minDateTime;

  final DateTime _maxDateTime = DateTime(
    DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        ).year +
        5,
    1,
    1,
  );

  DateTime get maxDateTime => _maxDateTime;

  DateTime? _pickedDateTime;

  DateTime? get pickedDateTime => _pickedDateTime;

  String? _error;

  String? get error => _error;

  PhaseChecklistCreateViewModel({required this.phaseId});

  // MARK: - API CALL

  Future createPhaseChecklist({required String name}) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<PhaseRepositoryInterface>()
        .createPhaseChecklist(PhaseChecklistRequest(
          phaseId: phaseId,
          name: name,
          deadline: _pickedDateTime?.toUtc().toIso8601String(),
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

  // MARK: - FUNCTION'S

  void changePickedDateTime(DateTime? dateTime) {
    if (dateTime == null) return;
    _pickedDateTime = dateTime;

    notifyListeners();
  }
}
