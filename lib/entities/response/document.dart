import 'dart:convert';

Document documentFromJson(String str) => Document.fromJson(json.decode(str));

String documentToJson(Document data) => json.encode(data.toJson());

class Document {
  Document({
    required this.filename,
    required this.id,
    required this.mimeType,
    required this.name,
    required this.taskId,
  });

  String filename;
  String id;
  String mimeType;
  String name;
  String taskId;

  factory Document.fromJson(Map<String, dynamic> json) => Document(
        filename: json["filename"],
        id: json["id"],
        mimeType: json["mime_type"],
        name: json["name"],
        taskId: json["task_id"],
      );

  Map<String, dynamic> toJson() => {
        "filename": filename,
        "id": id,
        "mime_type": mimeType,
        "name": name,
        "task_id": taskId,
      };
}
