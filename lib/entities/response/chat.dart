import 'dart:convert';

import 'package:izowork/entities/response/message.dart';
import 'package:izowork/entities/response/user.dart';

Chat chatFromJson(String str) => Chat.fromJson(json.decode(str));

String chatToJson(Chat data) => json.encode(data.toJson());

class Chat {
  Chat({
    this.avatar,
    required this.chatType,
    required this.id,
    this.lastMessage,
    this.name,
  });

  String? avatar;
  String chatType;
  String id;
  Message? lastMessage;
  String? name;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        avatar: json["avatar"],
        chatType: json["chat_type"],
        id: json["id"],
        lastMessage: json["last_message"] == null
            ? null
            : Message.fromJson(json["last_message"]),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "avatar": avatar,
        "chat_type": chatType,
        "id": id,
        "last_message": lastMessage?.toJson(),
        "name": name,
      };
}
