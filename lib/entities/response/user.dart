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

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        state: json["state"],
        name: json["name"] ?? '-',
        email: json["email"],
        phone: json["phone"] ?? '-',
        social: json["social"] == null
            ? []
            : List<String>.from(json["social"].map((x) => x)),
        post: json["post"] ?? '-',
        avatar: json["avatar"],
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
      };
}
