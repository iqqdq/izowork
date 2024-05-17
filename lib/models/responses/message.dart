import 'package:izowork/models/models.dart';

class Message {
  Message(
      {this.id,
      required this.createdAt,
      this.readAt,
      required this.text,
      required this.userId,
      required this.chatId,
      this.user,
      required this.files});

  String? id;
  DateTime createdAt;
  DateTime? readAt;
  String text;
  String userId;
  String chatId;
  User? user;
  List<Document> files;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]).toUtc().toLocal(),
        readAt: json["read_at"] == null
            ? null
            : DateTime.parse(json["read_at"]).toUtc().toLocal(),
        text: json["text"],
        userId: json["user_id"],
        chatId: json["chat_id"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        files: json["files"] == null
            ? []
            : List<Document>.from(
                json["files"].map((x) => Document.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt,
        "read_at": readAt,
        "text": text,
        "user_id": userId,
        "chat_id": chatId,
        "user": user,
        "files": files
      };
}
