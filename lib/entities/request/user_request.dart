import 'dart:convert';

String userRequestToJson(UserRequest data) => json.encode(data.toJson());

class UserRequest {
  UserRequest({
    this.email,
    this.name,
    this.phone,
    this.post,
    this.social,
  });

  String? email;
  String? name;
  String? phone;
  String? post;
  List<String>? social;

  Map<String, dynamic> toJson() => {
        "email": email,
        "name": name,
        "phone": phone,
        "post": post,
        "social": social,
      };
}
