import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/request/phase_checklist_message_request.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/phase_checklist.dart';
import 'package:izowork/repositories/phase_repository.dart';

class PhaseChecklistCommentsViewModel with ChangeNotifier {
  final PhaseChecklist phaseChecklist;

  LoadingStatus loadingStatus = LoadingStatus.empty;

  PhaseChecklistResponse? _phaseChecklistResponse;

  bool _isSending = false;

  PhaseChecklistResponse? get phaseChecklistResponse => _phaseChecklistResponse;

  bool get isSending => _isSending;

  PhaseChecklistCommentsViewModel({required this.phaseChecklist}) {
    // getPhaseChecklistCommentsList(pagination: Pagination(offset: 0, size: 20));
    // getPhaseChecklist();
  }

  Future getPhaseChecklist() async {
    await PhaseRepository()
        .getPhaseChecklist(phaseChecklist.id)
        .then((response) => {
              if (response is PhaseChecklistResponse)
                {
                  loadingStatus = LoadingStatus.completed,
                  _phaseChecklistResponse = response,
                }
              else if (response is ErrorResponse)
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => notifyListeners());
  }

  Future getPhaseChecklistCommentsList({required Pagination pagination}) async {
    // TODO: - GET PHASE CHECKLIST COMMENTS
  }

  Future sendComment({required String comment}) async {
    _isSending = true;
    notifyListeners();

    await PhaseRepository()
        .createPhaseChecklistComment(PhaseChecklistCommentRequest(
          id: phaseChecklist.id,
          comment: comment,
        ))
        .then((response) => {
              if (response == true)
                {
                  loadingStatus = LoadingStatus.completed,
                  // TODO: - UPDATE COMMENT LIST
                }
              else if (response is ErrorResponse)
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => {
              _isSending = false,
              notifyListeners(),
            });
  }
}
