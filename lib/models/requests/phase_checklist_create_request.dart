class PhaseChecklistRequest {
  final String name;
  final String phaseId;
  final String? deadline;

  PhaseChecklistRequest({
    required this.name,
    required this.phaseId,
    this.deadline,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "phase_id": phaseId,
        "deadline": deadline,
      };
}
