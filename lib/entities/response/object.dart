import 'dart:convert';
import 'package:izowork/entities/response/chat.dart';
import 'package:izowork/entities/response/company.dart';
import 'package:izowork/entities/response/document.dart';
import 'package:izowork/entities/response/object_stage.dart';
import 'package:izowork/entities/response/object_type.dart';
import 'package:izowork/entities/response/user.dart';

Object objectFromJson(String str) => Object.fromJson(json.decode(str));

String objectToJson(Object data) => json.encode(data.toJson());

class Object {
  Object(
      {required this.id,
      required this.name,
      required this.address,
      required this.long,
      required this.lat,
      this.floors,
      this.area,
      this.constructionPeriod,
      this.contractor,
      this.designer,
      this.customer,
      this.contractorId,
      this.designerId,
      this.customerId,
      this.objectTypeId,
      this.objectType,
      this.objectStageId,
      this.objectStage,
      required this.files,
      this.managerId,
      this.manager,
      this.kiso,
      required this.hideDir,
      required this.readiness,
      required this.efficiency,
      this.chat});

  String id;
  String name;
  String address;
  double long;
  double lat;
  int? floors;
  int? area;
  int? constructionPeriod;
  Company? contractor;
  Company? designer;
  Company? customer;
  String? contractorId;
  String? designerId;
  String? customerId;
  String? objectTypeId;
  ObjectType? objectType;
  String? objectStageId;
  ObjectStage? objectStage;
  List<Document> files;
  String? managerId;
  User? manager;
  String? kiso;
  bool hideDir;
  int readiness;
  int efficiency;
  Chat? chat;

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
      designer:
          json["designer"] == null ? null : Company.fromJson(json["designer"]),
      customer:
          json["customer"] == null ? null : Company.fromJson(json["customer"]),
      contractorId: json["contractor_id"],
      designerId: json["designer_id"],
      customerId: json["customer_id"],
      objectTypeId: json["object_type_id"],
      objectType: json["object_type_id"] == null
          ? null
          : ObjectType.fromJson(json["object_type"]),
      objectStageId: json["object_stage_id"],
      objectStage: json["object_stage"] == null
          ? null
          : ObjectStage.fromJson(json["object_stage"]),
      files: json["files"] == null
          ? []
          : List<Document>.from(json["files"].map((x) => Document.fromJson(x))),
      managerId: json["manager_id"],
      manager: json["manager"] == null ? null : User.fromJson(json["manager"]),
      kiso: json["kiso"],
      hideDir: json["hideDir"] == null ? false : true,
      readiness: json["readiness"],
      efficiency: json["efficiency"],
      chat: json["chat"] == null ? null : Chat.fromJson(json["chat"]));

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
        "manager_id": managerId,
        "manager": manager,
        "kiso": kiso,
        "hideDir": hideDir,
        "readiness": readiness,
        "efficiency": efficiency,
        "chat": chat
      };
}
