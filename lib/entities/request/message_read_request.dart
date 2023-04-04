import 'dart:convert';

String messageReadRequestToJson(MessageReadRequest data) =>
    json.encode(data.toJson());

class MessageReadRequest {
  MessageReadRequest({
    required this.chatId,
  });

  String chatId;

  Map<String, dynamic> toJson() => {"chat_id": chatId};
}
