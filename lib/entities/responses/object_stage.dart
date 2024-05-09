class ObjectStage {
  ObjectStage({
    required this.id,
    required this.name,
    this.color,
  });

  String id;
  String name;
  String? color;

  factory ObjectStage.fromJson(Map<String, dynamic> json) => ObjectStage(
        id: json["id"],
        name: json["name"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "color": color,
      };
}
