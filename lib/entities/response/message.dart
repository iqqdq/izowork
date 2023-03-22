import 'dart:convert';

import 'package:izowork/entities/response/user.dart';

Message messageFromJson(String str) => Message.fromJson(json.decode(str));

String messageToJson(Message data) => json.encode(data.toJson());

class Message {
  Message(
      {this.id,
      required this.createdAt,
      required this.text,
      required this.userId,
      required this.chatId,
      this.user});

  String? id;
  String createdAt;
  String text;
  String userId;
  String chatId;
  User? user;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
      id: json["id"],
      createdAt: json["created_at"],
      text: json["text"],
      userId: json["user_id"],
      chatId: json["chat_id"],
      user: json["user"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt,
        "text": text,
        "user_id": userId,
        "chat_id": chatId,
        "user": user
      };
}