// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/repositories/repositories.dart';

class PhaseChecklistMessagesViewModel with ChangeNotifier {
  final PhaseChecklist phaseChecklist;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  PhaseChecklistMessagesResponse _phaseChecklistMessagesResponse =
      PhaseChecklistMessagesResponse(
    count: 0,
    messages: [],
  );

  bool _isSending = false;

  PhaseChecklistMessagesResponse get phaseChecklistMessagesResponse =>
      _phaseChecklistMessagesResponse;

  bool get isSending => _isSending;

  PhaseChecklistMessagesViewModel({required this.phaseChecklist}) {
    getPhaseChecklistMessagesList(pagination: Pagination());
  }

  Future getPhaseChecklistMessagesList({required Pagination pagination}) async {
    if (pagination.offset == 0) {
      _phaseChecklistMessagesResponse.messages.clear();

      loadingStatus = LoadingStatus.searching;
      notifyListeners();
    }

    await sl<PhaseRepositoryInterface>()
        .getPhaseChecklistMessages(
          pagination: pagination,
          id: phaseChecklist.id,
        )
        .then((response) => {
              if (response is PhaseChecklistMessagesResponse)
                {
                  _phaseChecklistMessagesResponse = response,
                  loadingStatus = LoadingStatus.completed,
                }
              else
                loadingStatus = LoadingStatus.error,
            })
        .then((value) => notifyListeners());
  }

  Future sendMessage({required String message}) async {
    _isSending = true;
    notifyListeners();

    await sl<PhaseRepositoryInterface>()
        .createPhaseChecklistMessage(PhaseChecklistMessageRequest(
          id: phaseChecklist.id,
          body: message,
        ))
        .then((response) => {
              if (response is PhaseChecklistMessage)
                {
                  loadingStatus = LoadingStatus.completed,
                  _phaseChecklistMessagesResponse.messages.insert(0, response),
                  _phaseChecklistMessagesResponse.count++,
                }
              else if (response is ErrorResponse)
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => _isSending = false)
        .then((value) => notifyListeners());
  }
}
