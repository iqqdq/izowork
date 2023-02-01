import 'dart:convert';

Authorization authorizationFromJson(String str) =>
    Authorization.fromJson(json.decode(str));

String authorizationToJson(Authorization data) => json.encode(data.toJson());

class Authorization {
  Authorization({
    required this.token,
    required this.state,
  });

  String token;
  String state;

  factory Authorization.fromJson(Map<String, dynamic> json) => Authorization(
        token: json["token"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "state": state,
      };
}
