class PhaseChecklistInfoRequest {
  PhaseChecklistInfoRequest({
    required this.description,
    required this.phaseChecklistId,
  });

  String description;
  String phaseChecklistId;

  Map<String, dynamic> toJson() => {
        "description": description,
        "phase_checklist_id": phaseChecklistId,
      };
}
