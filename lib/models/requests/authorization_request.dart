import 'dart:convert';

String authorizationToJson(AuthorizationRequest data) =>
    json.encode(data.toJson());

class AuthorizationRequest {
  AuthorizationRequest({
    required this.email,
    required this.password,
  });

  String email;
  String password;

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}
