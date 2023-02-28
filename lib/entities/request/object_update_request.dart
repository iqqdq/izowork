import 'dart:convert';

String objectRequestToJson(ObjectUpdateRequest data) =>
    json.encode(data.toJson());

class ObjectUpdateRequest {
  ObjectUpdateRequest({
    required this.id,
    required this.address,
    this.area,
    this.constructionPeriod,
    this.contractorId,
    this.customerId,
    this.designerId,
    this.floors,
    required this.lat,
    required this.long,
    required this.name,
    required this.objectStageId,
    required this.objectTypeId,
  });

  String id;
  String address;
  int? area;
  int? constructionPeriod;
  String? contractorId;
  String? customerId;
  String? designerId;
  int? floors;
  double lat;
  double long;
  String name;
  String objectStageId;
  String objectTypeId;

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address,
        "area": area,
        "construction_period": constructionPeriod,
        "contractor_id": contractorId,
        "customer_id": customerId,
        "designer_id": designerId,
        "floors": floors,
        "lat": lat,
        "long": long,
        "name": name,
        "object_stage_id": objectStageId,
        "object_type_id": objectTypeId,
      };
}
