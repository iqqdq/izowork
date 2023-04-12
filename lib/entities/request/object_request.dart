import 'dart:convert';

String objectRequestToJson(ObjectRequest data) => json.encode(data.toJson());

class ObjectRequest {
  ObjectRequest({
    this.id,
    required this.address,
    this.area,
    this.constructionPeriod,
    this.managerId,
    this.contractorId,
    this.customerId,
    this.designerId,
    this.floors,
    required this.lat,
    required this.long,
    required this.name,
    required this.objectStageId,
    required this.objectTypeId,
    required this.hideDir,
    this.kiso,
  });

  String? id;
  String address;
  int? area;
  int? constructionPeriod;
  String? managerId;
  String? contractorId;
  String? customerId;
  String? designerId;
  int? floors;
  double lat;
  double long;
  String name;
  String objectStageId;
  String objectTypeId;
  bool hideDir;
  String? kiso;

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address,
        "area": area,
        "construction_period": constructionPeriod,
        "manager_id": managerId,
        "contractor_id": contractorId,
        "customer_id": customerId,
        "designer_id": designerId,
        "floors": floors,
        "lat": lat,
        "long": long,
        "name": name,
        "object_stage_id": objectStageId,
        "object_type_id": objectTypeId,
        "hide_dir": hideDir,
        "kiso": kiso,
      };
}
