import 'dart:convert';

CompanyRequest companyRequestFromJson(String str) =>
    CompanyRequest.fromJson(json.decode(str));

String companyRequestToJson(CompanyRequest data) => json.encode(data.toJson());

class CompanyRequest {
  CompanyRequest({
    required this.address,
    this.description,
    this.details,
    this.email,
    required this.name,
    required this.phone,
    required this.type,
  });

  String address;
  String? description;
  String? details;
  String? email;
  String name;
  String phone;
  String type;

  factory CompanyRequest.fromJson(Map<String, dynamic> json) => CompanyRequest(
        address: json["address"],
        description: json["description"],
        details: json["details"],
        email: json["email"],
        name: json["name"],
        phone: json["phone"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "description": description,
        "details": details,
        "email": email,
        "name": name,
        "phone": phone,
        "type": type,
      };
}
