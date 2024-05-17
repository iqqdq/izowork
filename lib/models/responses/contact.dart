import 'package:izowork/models/models.dart';

class Contact {
  Contact({
    required this.id,
    required this.name,
    this.post,
    this.phone,
    this.email,
    required this.social,
    this.avatar,
    this.companyId,
    this.company,
  });

  String id;
  String name;
  String? post;
  String? phone;
  String? email;
  List<String> social;
  String? avatar;
  String? companyId;
  Company? company;

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        id: json["id"],
        name: json["name"] == '' ? null : json["name"],
        post: json["post"] == '' ? null : json["post"],
        phone: json["phone"] == '' ? null : json["phone"],
        email: json["email"] == '' ? null : json["email"],
        social: json["social"] == null
            ? []
            : List<String>.from(json["social"].map((x) => x)),
        avatar: json["avatar"],
        companyId: json["company_id"],
        company:
            json["company"] == null ? null : Company.fromJson(json["company"]),
      );
}
