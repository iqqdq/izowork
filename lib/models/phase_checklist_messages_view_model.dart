// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';

import 'package:izowork/entities/requests/requests.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/repositories/repositories.dart';

class PhaseChecklistMessagesViewModel with ChangeNotifier {
  final PhaseChecklist phaseChecklist;

  LoadingStatus loadingStatus = LoadingStatus.empty;

  final List<PhaseChecklistMessage> _phaseChecklistMessages = [];

  bool _isSending = false;

  List<PhaseChecklistMessage> get phaseChecklistMessages =>
      _phaseChecklistMessages;

  bool get isSending => _isSending;

  PhaseChecklistMessagesViewModel({required this.phaseChecklist}) {
    getPhaseChecklistMessagesList(
        pagination: Pagination(
      offset: 0,
      size: 20,
    ));
  }

  Future getPhaseChecklistMessagesList({required Pagination pagination}) async {
    if (pagination.offset == 0) {
      loadingStatus = LoadingStatus.searching;
      _phaseChecklistMessages.clear();

      Future.delayed(Duration.zero, () async => notifyListeners());
    }

    await PhaseRepository()
        .getPhaseChecklistMessages(
          pagination: pagination,
          id: phaseChecklist.id,
        )
        .then((response) => {
              if (response is List<PhaseChecklistMessage>)
                {
                  if (_phaseChecklistMessages.isEmpty)
                    {
                      response.forEach((phaseChecklistMessage) {
                        _phaseChecklistMessages.add(phaseChecklistMessage);
                      })
                    }
                  else
                    {
                      response.forEach((newPhaseChecklistMessage) {
                        bool found = false;

                        _phaseChecklistMessages
                            .forEach((phaseChecklistMessage) {
                          if (newPhaseChecklistMessage.id ==
                              phaseChecklistMessage.id) {
                            found = true;
                          }
                        });

                        if (!found) {
                          _phaseChecklistMessages.add(newPhaseChecklistMessage);
                        }
                      })
                    },
                  loadingStatus = LoadingStatus.completed
                }
              else
                loadingStatus = LoadingStatus.error,
            })
        .then((value) => notifyListeners());
  }

  Future sendMessage({required String message}) async {
    _isSending = true;
    notifyListeners();

    await PhaseRepository()
        .createPhaseChecklistMessage(PhaseChecklistMessageRequest(
          id: phaseChecklist.id,
          body: message,
        ))
        .then((response) => {
              if (response is PhaseChecklistMessage)
                {
                  loadingStatus = LoadingStatus.completed,
                  _phaseChecklistMessages.add(response),
                }
              else if (response is ErrorResponse)
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => _isSending = false)
        .then((value) => notifyListeners());
  }
}
