class ObjectFolderRequest {
  final String name;
  final String objectId;
  final String? parentFolder;

  ObjectFolderRequest({
    required this.name,
    required this.objectId,
    this.parentFolder,
  });

  Map<String, dynamic> toJson() => parentFolder == null
      ? {
          "name": name,
          "object_id": objectId,
        }
      : {
          "name": name,
          "object_id": objectId,
          "parent_folder": parentFolder,
        };
}
