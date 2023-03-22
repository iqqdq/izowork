import 'dart:convert';

String chatConnectRequestRequestToJson(ChatConnectRequest data) =>
    json.encode(data.toJson());

class ChatConnectRequest {
  ChatConnectRequest({required this.accessToken});

  String accessToken;

  Map<String, dynamic> toJson() => {"access_token": accessToken};
}
