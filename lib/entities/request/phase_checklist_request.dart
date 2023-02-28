import 'dart:convert';

PhaseChecklistInformationRequest checklistPhaseInformationRequestFromJson(
        String str) =>
    PhaseChecklistInformationRequest.fromJson(json.decode(str));

String checklistPhaseInfromationRequestToJson(
        PhaseChecklistInformationRequest data) =>
    json.encode(data.toJson());

class PhaseChecklistInformationRequest {
  PhaseChecklistInformationRequest({
    required this.description,
    required this.phaseChecklistId,
  });

  String description;
  String phaseChecklistId;

  factory PhaseChecklistInformationRequest.fromJson(
          Map<String, dynamic> json) =>
      PhaseChecklistInformationRequest(
        description: json["description"],
        phaseChecklistId: json["phase_checklist_id"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "phase_checklist_id": phaseChecklistId,
      };
}
