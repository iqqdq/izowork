import 'dart:convert';

Company companyJson(String str) => Company.fromJson(json.decode(str));

String companyToJson(Company data) => json.encode(data.toJson());

class Company {
  Company({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    this.email,
    this.details,
    this.description,
    this.image,
    required this.type,
  });

  String id;
  String name;
  String address;
  String phone;
  String? email;
  String? details;
  String? description;
  String? image;
  String type;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        phone: json["phone"],
        email: json["email"] ?? '-',
        details: json["details"] ?? '-',
        description: json["description"] ?? '-',
        image: json["image"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "phone": phone,
        "email": email,
        "details": details,
        "description": description,
        "image": image,
        "type": type,
      };
}
