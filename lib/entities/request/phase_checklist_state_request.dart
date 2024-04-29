class PhaseChecklistStateRequest {
  PhaseChecklistStateRequest({
    required this.id,
    required this.state,
  });

  String id;
  String state;

  Map<String, dynamic> toJson() => {
        "id": id,
        "state": state,
      };
}
