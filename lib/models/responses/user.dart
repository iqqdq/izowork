import 'package:izowork/models/models.dart';

class User {
  User({
    required this.id,
    this.createdAt,
    required this.state,
    required this.name,
    required this.email,
    required this.phone,
    required this.social,
    required this.post,
    this.avatar,
    required this.roles,
    required this.offices,
  });

  String id;
  DateTime? createdAt;
  String state;
  String name;
  String email;
  String phone;
  List<String> social;
  String post;
  String? avatar;
  List<Role>? roles;
  List<Office>? offices;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]).toUtc().toLocal(),
        state: json["state"],
        name: json["name"] ?? '-',
        email: json["email"],
        phone: json["phone"] ?? '-',
        social: json["social"] == null
            ? []
            : List<String>.from(json["social"].map((x) => x)),
        post: json["post"] ?? '-',
        avatar: json["avatar"],
        roles: json["roles"] == null
            ? null
            : List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
        offices: json["offices"] == null
            ? null
            : List<Office>.from(json["offices"].map((x) => Office.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "state": state,
        "name": name,
        "email": email,
        "phone": phone,
        "social": List<dynamic>.from(social.map((x) => x)),
        "post": post,
        "avatar": avatar,
        "roles": roles == null
            ? null
            : List<dynamic>.from(roles!.map((x) => x.toJson())),
        "offices": offices == null
            ? null
            : List<dynamic>.from(offices!.map((x) => x.toJson())),
      };
}

class Role {
  String id;
  String name;
  String alias;

  Role({
    required this.id,
    required this.name,
    required this.alias,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        name: json["name"],
        alias: json["alias"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "alias": alias,
      };
}
