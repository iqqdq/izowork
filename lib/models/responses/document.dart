class Document {
  final String id;
  final String name;
  final bool pinned;
  final bool isFolder;
  // final DateTime createdAt;
  final String? filename;
  final String? mimeType;
  final String? officeId;
  final String? folderId;
  final bool? isCommon;
  final String? parentFolder;

  Document({
    required this.id,
    required this.name,
    required this.pinned,
    required this.isFolder,
    // required this.createdAt,
    this.filename,
    this.mimeType,
    this.officeId,
    this.folderId,
    this.isCommon,
    this.parentFolder,
  });

  factory Document.fromJson(Map<String, dynamic> json) => Document(
        id: json["id"],
        name: json["name"],
        filename: json["filename"],
        mimeType: json["mime_type"],
        officeId: json["office_id"],
        pinned: json.containsKey("pinned") ? json["pinned"] : false,
        folderId: json["folder_id"],
        isCommon: json["is_common"],
        parentFolder: json["parent_folder"],
        isFolder: json.containsKey("is_folder") ? json["is_folder"] : false,
        // createdAt: DateTime.parse(json["created_at"]),
      );
}
