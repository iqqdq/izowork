// class Document {
//   Document({
//     required this.filename,
//     required this.id,
//     required this.mimeType,
//     required this.name,
//     this.namespace,
//     this.type,
//     this.dealId,
//     this.messageId,
//     this.pinned,
//   });

//   final String id;
//   final String name;
//   final String? filename;
//   final String? mimeType;
//   final String? namespace;
//   final String? type;
//   final String? dealId;
//   final String? messageId;
//   final bool? pinned;

//   factory Document.fromJson(Map<String, dynamic> json) => Document(
//         id: json["id"],
//         name: json["name"],
//         filename: json["filename"],
//         mimeType: json["mime_type"],
//         namespace: json["namespace"],
//         type: json["type"],
//         dealId: json["deal_id"],
//         messageId: json["message_id"],
//         pinned: json["pinned"],
//       );

//   Map<String, dynamic> toJson() => {
//         "filename": filename,
//         "id": id,
//         "mime_type": mimeType,
//         "name": name,
//         "namespace": namespace,
//         "type": type,
//         "deal_id": dealId,
//         "messageId": messageId,
//         "pinned": pinned,
//       };
// }
