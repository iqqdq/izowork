import 'dart:convert';

String contactRequestToJson(ContactRequest data) => json.encode(data.toJson());

class ContactRequest {
  ContactRequest({
    this.companyId,
    this.email,
    this.id,
    this.name,
    this.phone,
    this.social,
  });

  String? companyId;
  String? email;
  String? id;
  String? name;
  String? phone;
  List<String>? social;

  Map<String, dynamic> toJson() => {
        "company_id": companyId,
        "email": email,
        "id": id,
        "name": name,
        "phone": phone,
        "social":
            social == null ? null : List<dynamic>.from(social!.map((x) => x)),
      };
}
