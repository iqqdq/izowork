import 'dart:convert';

import 'package:izowork/entities/response/office.dart';

Trace traceFromJson(String str) => Trace.fromJson(json.decode(str));

String traceToJson(Trace data) => json.encode(data.toJson());

class Trace {
  Trace(
      {required this.id,
      this.subjectId,
      this.objectId,
      this.traceTypeId,
      this.traceGroupId,
      this.description,
      required this.createdAt,
      required this.traceType,
      required this.traceGroup,
      this.office});

  String id;
  String? subjectId;
  String? objectId;
  String? traceTypeId;
  String? traceGroupId;
  String? description;
  DateTime createdAt;
  TraceType traceType;
  TraceGroup traceGroup;
  Office? office;

  factory Trace.fromJson(Map<String, dynamic> json) => Trace(
        id: json["id"],
        subjectId: json["subject_id"],
        objectId: json["object_id"],
        traceTypeId: json["trace_type_id"],
        traceGroupId: json["trace_group_id"],
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
        traceType: TraceType.fromJson(json["trace_type"]),
        traceGroup: TraceGroup.fromJson(json["trace_group"]),
        office: json["office"] == null ? null : Office.fromJson(json["office"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subject_id": subjectId,
        "object_id": objectId,
        "trace_type_id": traceTypeId,
        "trace_group_id": traceGroupId,
        "description": description,
        "created_at": createdAt.toIso8601String(),
        "trace_type": traceType.toJson(),
        "trace_group": traceGroup.toJson(),
        "office": office?.toJson()
      };
}

class TraceGroup {
  TraceGroup({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory TraceGroup.fromJson(Map<String, dynamic> json) => TraceGroup(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class TraceType {
  TraceType({
    required this.id,
    required this.traceGroupId,
    required this.name,
  });

  String id;
  String traceGroupId;
  String name;

  factory TraceType.fromJson(Map<String, dynamic> json) => TraceType(
        id: json["id"],
        traceGroupId: json["trace_group_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "trace_group_id": traceGroupId,
        "name": name,
      };
}