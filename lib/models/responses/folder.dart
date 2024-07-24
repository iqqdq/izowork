class Folder {
  final DateTime createdAt;
  final String id;
  final String name;
  final String objectId;
  String? parentFolder;

  Folder({
    required this.createdAt,
    required this.id,
    required this.name,
    required this.objectId,
    this.parentFolder,
  });

  factory Folder.fromJson(Map<String, dynamic> json) => Folder(
        createdAt: DateTime.parse(json["created_at"]).toUtc().toLocal(),
        id: json["id"],
        name: json["name"],
        objectId: json.containsKey("object_id")
            ? json["object_id"]
            : json["checklist_information_id"],
        parentFolder: json["parent_folder"],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt,
        "id": id,
        "name": name,
        "object_id": objectId,
        "parent_folder": parentFolder,
      };
}
