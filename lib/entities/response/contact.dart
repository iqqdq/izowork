import 'dart:convert';
import 'package:izowork/entities/response/company.dart';

Contact contactFromJson(String str) => Contact.fromJson(json.decode(str));

String contactToJson(Contact data) => json.encode(data.toJson());

class Contact {
  Contact({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    required this.social,
    this.avatar,
    this.companyId,
    this.company,
  });

  String id;
  String name;
  String? phone;
  String? email;
  List<String> social;
  String? avatar;
  String? companyId;
  Company? company;

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        social: json["social"] == null
            ? []
            : List<String>.from(json["social"].map((x) => x)),
        avatar: json["avatar"],
        companyId: json["company_id"],
        company:
            json["company"] == null ? null : Company.fromJson(json["company"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "email": email,
        "social": List<dynamic>.from(social.map((x) => x)),
        "avatar": avatar,
        "company_id": companyId,
        "company": company?.toJson(),
      };
}
