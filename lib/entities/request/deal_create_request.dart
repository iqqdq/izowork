import 'dart:convert';

String dealCreateRequestToJson(DealCreateRequest data) =>
    json.encode(data.toJson());

class DealCreateRequest {
  DealCreateRequest({
    this.id,
    this.comment,
    this.companyId,
    required this.finishAt,
    this.objectId,
    this.responsibleId,
  });

  String? id;
  String? comment;
  String? companyId;
  String finishAt;
  String? objectId;
  String? responsibleId;

  Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
        "company_id": companyId,
        "finish_at": finishAt,
        "object_id": objectId,
        "responsible_id": responsibleId,
      };
}
