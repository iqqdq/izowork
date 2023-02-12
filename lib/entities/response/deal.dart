import 'dart:convert';

Deal dealFromJson(String str) => Deal.fromJson(json.decode(str));

String dealToJson(Deal data) => json.encode(data.toJson());

class Deal {
  Deal({
    required this.id,
    required this.number,
    required this.createdAt,
    required this.finishAt,
    required this.responsibleId,
    required this.objectId,
    required this.companyId,
    required this.comment,
    required this.files,
  });

  String id;
  int number;
  DateTime createdAt;
  DateTime finishAt;
  String responsibleId;
  String objectId;
  String companyId;
  String comment;
  List<dynamic> files;

  factory Deal.fromJson(Map<String, dynamic> json) => Deal(
        id: json["id"],
        number: json["number"],
        createdAt: DateTime.parse(json["created_at"]),
        finishAt: DateTime.parse(json["finish_at"]),
        responsibleId: json["responsible_id"],
        objectId: json["object_id"],
        companyId: json["company_id"],
        comment: json["comment"],
        files: List<dynamic>.from(json["files"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "number": number,
        "created_at": createdAt.toIso8601String(),
        "finish_at": finishAt.toIso8601String(),
        "responsible_id": responsibleId,
        "object_id": objectId,
        "company_id": companyId,
        "comment": comment,
        "files": List<dynamic>.from(files.map((x) => x)),
      };
}
