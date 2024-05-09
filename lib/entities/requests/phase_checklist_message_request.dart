class PhaseChecklistMessageRequest {
  PhaseChecklistMessageRequest({
    required this.id,
    required this.body,
  });

  String id;
  String body;

  Map<String, dynamic> toJson() => {
        "checklist_id": id,
        "body": body,
      };
}
