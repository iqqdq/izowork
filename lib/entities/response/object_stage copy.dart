import 'dart:convert';

ObjectType objectStageFromJson(String str) =>
    ObjectType.fromJson(json.decode(str));

String objectStageToJson(ObjectType data) => json.encode(data.toJson());

class ObjectType {
  ObjectType({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory ObjectType.fromJson(Map<String, dynamic> json) => ObjectType(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
