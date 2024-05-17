import 'dart:convert';

String chatDmRequestToJson(ChatDmRequest data) => json.encode(data.toJson());

class ChatDmRequest {
  ChatDmRequest({
    required this.userId,
  });

  String userId;

  Map<String, dynamic> toJson() => {'user_id': userId};
}
