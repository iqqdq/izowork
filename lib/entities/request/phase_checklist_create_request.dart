class PhaseChecklistCreateRequest {
  final String? name;
  final String? phaseId;

  PhaseChecklistCreateRequest({
    this.name,
    this.phaseId,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "phase_id": phaseId,
      };
}
