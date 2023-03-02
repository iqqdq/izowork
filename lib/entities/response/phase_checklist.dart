import 'dart:convert';

PhaseChecklist phaseChecklistFromJson(String str) =>
    PhaseChecklist.fromJson(json.decode(str));

String phaseChecklistToJson(PhaseChecklist data) => json.encode(data.toJson());

abstract class PhaseChecklistState {
  static const created = 'NEW';
  static const rejected = 'REJECTED';
  static const accepted = 'ACCEPTED';
  static const underReview = 'UNDER_REVIEW';
}

class PhaseChecklist {
  PhaseChecklist({
    required this.id,
    required this.phaseId,
    required this.state,
    required this.isCompleted,
    required this.name,
  });

  String id;
  String phaseId;
  String state;
  bool isCompleted;
  String name;

  factory PhaseChecklist.fromJson(Map<String, dynamic> json) => PhaseChecklist(
        id: json["id"],
        phaseId: json["phase_id"],
        state: json["state"],
        isCompleted: json["is_completed"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phase_id": phaseId,
        "state": state,
        "is_completed": isCompleted,
        "name": name,
      };
}
