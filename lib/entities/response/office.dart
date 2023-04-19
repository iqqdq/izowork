import 'dart:convert';

Office officeFromJson(String str) => Office.fromJson(json.decode(str));

String officeToJson(Office data) => json.encode(data.toJson());

class Office {
  Office({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory Office.fromJson(Map<String, dynamic> json) => Office(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
