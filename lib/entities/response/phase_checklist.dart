import 'dart:convert';

PhaseChecklistResponse phaseChecklistResponseFromJson(String str) =>
    PhaseChecklistResponse.fromJson(json.decode(str));

String phaseChecklistResponseToJson(PhaseChecklistResponse data) =>
    json.encode(data.toJson());

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
        phaseChecklists: List<PhaseChecklist>.from(
            json["phase_checklists"].map((x) => PhaseChecklist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "can_edit": canEdit,
        "phase_checklists":
            List<dynamic>.from(phaseChecklists.map((x) => x.toJson())),
      };
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
  final String state;
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

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_completed": isCompleted,
        "name": name,
        "phase_id": phaseId,
        "state": state,
        "type": type,
      };
}
