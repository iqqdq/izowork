import 'dart:convert';

Document documentFromJson(String str) => Document.fromJson(json.decode(str));

String documentToJson(Document data) => json.encode(data.toJson());

class Document {
  Document(
      {required this.filename,
      required this.id,
      required this.mimeType,
      required this.name,
      this.namespace,
      this.type,
      this.dealId,
      this.messageId});

  String filename;
  String id;
  String mimeType;
  String name;
  String? namespace;
  String? type;
  String? dealId;
  String? messageId;

  factory Document.fromJson(Map<String, dynamic> json) => Document(
      filename: json["filename"],
      id: json["id"],
      mimeType: json["mime_type"] ?? json["mimetype"],
      name: json["name"],
      namespace: json["namespace"],
      type: json["type"],
      dealId: json["deal_id"],
      messageId: json["message_id"]);

  Map<String, dynamic> toJson() => {
        "filename": filename,
        "id": id,
        "mime_type": mimeType,
        "name": name,
        "namespace": namespace,
        "type": type,
        "deal_id": dealId,
        "messageId": messageId
      };
}
