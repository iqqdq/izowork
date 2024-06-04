class Phase {
  Phase({
    required this.efficiency,
    required this.id,
    required this.name,
    required this.objectId,
    required this.readiness,
    required this.amountUnderReviewChecklist,
  });

  int efficiency;
  String id;
  String name;
  String objectId;
  int readiness;
  int amountUnderReviewChecklist;

  factory Phase.fromJson(Map<String, dynamic> json) => Phase(
        efficiency: json["efficiency"],
        id: json["id"],
        name: json["name"],
        objectId: json["object_id"],
        readiness: json["readiness"],
        amountUnderReviewChecklist: json["amount_under_review_checklist"],
      );

  Map<String, dynamic> toJson() => {
        "efficiency": efficiency,
        "id": id,
        "name": name,
        "object_id": objectId,
        "readiness": readiness,
        "amount_under_review_checklist": amountUnderReviewChecklist,
      };
}
