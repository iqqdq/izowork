import 'dart:convert';

Phase phaseFromJson(String str) => Phase.fromJson(json.decode(str));

String phaseToJson(Phase data) => json.encode(data.toJson());

class Phase {
  Phase({
    required this.efficiency,
    required this.id,
    required this.name,
    required this.objectId,
    required this.readiness,
  });

  int efficiency;
  String id;
  String name;
  String objectId;
  int readiness;

  factory Phase.fromJson(Map<String, dynamic> json) => Phase(
        efficiency: json["efficiency"],
        id: json["id"],
        name: json["name"],
        objectId: json["object_id"],
        readiness: json["readiness"],
      );

  Map<String, dynamic> toJson() => {
        "efficiency": efficiency,
        "id": id,
        "name": name,
        "object_id": objectId,
        "readiness": readiness,
      };
}
