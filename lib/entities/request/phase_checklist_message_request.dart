class PhaseChecklistCommentRequest {
  PhaseChecklistCommentRequest({
    required this.id,
    required this.comment,
  });

  String id;
  String comment;

  Map<String, dynamic> toJson() => {
        "checklist_id": id,
        "body": comment,
      };
}
