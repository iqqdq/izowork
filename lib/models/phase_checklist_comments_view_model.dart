import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/response/phase_checklist.dart';

class PhaseChecklistCommentsViewModel with ChangeNotifier {
  final PhaseChecklist phaseChecklist;

  LoadingStatus loadingStatus = LoadingStatus.empty;

  bool _isSending = false;

  bool get isSending => _isSending;

  PhaseChecklistCommentsViewModel({required this.phaseChecklist}) {
    getPhaseChecklistCommentsList(pagination: Pagination(offset: 0, size: 20));
  }

  Future getPhaseChecklistCommentsList({required Pagination pagination}) async {
    // TODO: - GET PHASE CHECKLIST COMMENTS
  }
}
