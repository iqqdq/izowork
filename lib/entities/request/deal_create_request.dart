import 'dart:convert';

String dealCreateRequestToJson(DealCreateRequest data) =>
    json.encode(data.toJson());

class DealCreateRequest {
  DealCreateRequest({
    this.id,
    this.comment,
    this.companyId,
    required this.createdAt,
    required this.finishAt,
    this.objectId,
    this.responsibleId,
    required this.closed,
  });

  String? id;
  String? comment;
  String? companyId;
  String createdAt;
  String finishAt;
  String? objectId;
  String? responsibleId;
  bool closed;

  Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
        "company_id": companyId,
        "finish_at": finishAt,
        "created_at": createdAt,
        "object_id": objectId,
        "responsible_id": responsibleId,
        "closed": closed,
      };
}
