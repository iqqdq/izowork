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
