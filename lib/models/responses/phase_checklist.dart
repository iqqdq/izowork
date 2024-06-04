class PhaseChecklistResponse {
  final bool canEdit;
  List<PhaseChecklist> phaseChecklists;

  PhaseChecklistResponse({
    required this.canEdit,
    required this.phaseChecklists,
  });

  factory PhaseChecklistResponse.fromJson(Map<String, dynamic> json) =>
      PhaseChecklistResponse(
        canEdit: json["can_edit"],
        phaseChecklists: json.containsKey("phase_checklists")
            ? List<PhaseChecklist>.from(json["phase_checklists"].map(
                (x) => PhaseChecklist.fromJson(x),
              ))
            : [
                PhaseChecklist.fromJson(json["phase_checklist"]),
              ],
      );
}

abstract class PhaseChecklistState {
  static const created = 'NEW';
  static const rejected = 'REJECTED';
  static const accepted = 'ACCEPTED';
  static const underReview = 'UNDER_REVIEW';
}

class PhaseChecklist {
  final String id;
  final bool isCompleted;
  final String name;
  final String phaseId;
  String state;
  final String type;

  PhaseChecklist({
    required this.id,
    required this.isCompleted,
    required this.name,
    required this.phaseId,
    required this.state,
    required this.type,
  });

  factory PhaseChecklist.fromJson(Map<String, dynamic> json) => PhaseChecklist(
        id: json["id"],
        isCompleted: json["is_completed"],
        name: json["name"],
        phaseId: json["phase_id"],
        state: json["state"],
        type: json["type"],
      );
}
