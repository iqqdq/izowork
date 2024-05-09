class DealRequest {
  DealRequest({
    this.id,
    this.comment,
    this.companyId,
    required this.createdAt,
    required this.finishAt,
    this.objectId,
    this.responsibleId,
    this.phaseId,
    required this.closed,
  });

  String? id;
  String? comment;
  String? companyId;
  String createdAt;
  String finishAt;
  String? objectId;
  String? responsibleId;
  String? phaseId;
  bool closed;

  Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
        "company_id": companyId,
        "finish_at": finishAt,
        "created_at": createdAt,
        "object_id": objectId,
        "responsible_id": responsibleId,
        "phase_id": phaseId,
        "closed": closed,
      };
}
