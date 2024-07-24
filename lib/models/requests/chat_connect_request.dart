class ChatConnectRequest {
  ChatConnectRequest({required this.accessToken});

  String accessToken;

  Map<String, dynamic> toJson() => {"access_token": accessToken};
}
