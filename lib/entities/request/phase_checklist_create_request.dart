class PhaseChecklistRequest {
  final String? name;
  final String? phaseId;

  PhaseChecklistRequest({
    this.name,
    this.phaseId,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "phase_id": phaseId,
      };
}
