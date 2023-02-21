import 'dart:convert';

import 'package:izowork/entities/response/company.dart';
import 'package:izowork/entities/response/document.dart';
import 'package:izowork/entities/response/user.dart';

Object objectFromJson(String str) => Object.fromJson(json.decode(str));

String objectToJson(Object data) => json.encode(data.toJson());

class Object {
  Object({
    required this.id,
    required this.name,
    required this.address,
    required this.long,
    required this.lat,
    required this.floors,
    required this.area,
    required this.constructionPeriod,
    this.contractor,
    this.designer,
    this.customer,
    this.contractorId,
    this.designerId,
    this.customerId,
    this.objectTypeId,
    this.objectStageId,
    required this.files,
  });

  String id;
  String name;
  String address;
  double long;
  double lat;
  int floors;
  int area;
  int constructionPeriod;
  Company? contractor;
  Company? designer;
  Company? customer;
  String? contractorId;
  String? designerId;
  String? customerId;
  String? objectTypeId;
  String? objectStageId;
  List<Document> files;

  factory Object.fromJson(Map<String, dynamic> json) => Object(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        long: json["long"]?.toDouble(),
        lat: json["lat"]?.toDouble(),
        floors: json["floors"],
        area: json["area"],
        constructionPeriod: json["construction_period"],
        contractor: json["contractor"] == null
            ? null
            : Company.fromJson(json["contractor"]),
        designer: json["designer"] == null
            ? null
            : Company.fromJson(json["designer"]),
        customer: json["customer"] == null
            ? null
            : Company.fromJson(json["customer"]),
        contractorId: json["contractor_id"],
        designerId: json["designer_id"],
        customerId: json["customer_id"],
        objectTypeId: json["object_type_id"],
        objectStageId: json["object_stage_id"],
        files: json["files"] == null
            ? []
            : List<Document>.from(
                json["files"].map((x) => Document.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "long": long,
        "lat": lat,
        "floors": floors,
        "area": area,
        "construction_period": constructionPeriod,
        "contractor_id": contractorId,
        "designer_id": designerId,
        "customer_id": customerId,
        "object_type_id": objectTypeId,
        "object_stage_id": objectStageId,
        "files": List<Document>.from(files.map((x) => x)),
      };
}
