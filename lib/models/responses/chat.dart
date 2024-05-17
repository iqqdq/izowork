import 'package:izowork/models/models.dart';

class Chat {
  Chat(
      {this.avatar,
      required this.chatType,
      required this.id,
      this.lastMessage,
      this.name,
      this.user,
      required this.files,
      required this.unreadCount});

  String? avatar;
  String chatType;
  String id;
  Message? lastMessage;
  String? name;
  User? user;
  List<Document> files;
  int unreadCount;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
      avatar: json["avatar"],
      chatType: json["chat_type"],
      id: json["id"],
      lastMessage: json["last_message"] == null
          ? null
          : Message.fromJson(json["last_message"]),
      name: json["name"],
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      files: json["files"] == null
          ? []
          : List<Document>.from(json["files"].map((x) => Document.fromJson(x))),
      unreadCount: json["unread_count"] ?? 0);

  Map<String, dynamic> toJson() => {
        "avatar": avatar,
        "chat_type": chatType,
        "id": id,
        "last_message": lastMessage?.toJson(),
        "name": name,
        "user": user,
        "files": files,
        "unread_count": unreadCount
      };
}
