import 'dart:convert';

String messageRequestRequestToJson(MessageRequest data) =>
    json.encode(data.toJson());

class MessageRequest {
  MessageRequest({
    required this.chatId,
    required this.accessToken,
    required this.message,
  });

  String chatId;
  String accessToken;
  String message;

  Map<String, dynamic> toJson() => {
        "chat_id": chatId,
        "access_token": accessToken,
        "message": message,
      };
}
