import 'dart:convert';

import 'package:izowork/entities/response/product_type.dart';

Company companyJson(String str) => Company.fromJson(json.decode(str));

String companyToJson(Company data) => json.encode(data.toJson());

class Company {
  Company(
      {required this.id,
      required this.name,
      required this.address,
      required this.phone,
      this.email,
      this.details,
      this.description,
      this.image,
      required this.type,
      required this.successfulDeals,
      this.productType});

  String id;
  String name;
  String address;
  String phone;
  String? email;
  String? details;
  String? description;
  String? image;
  String type;
  int? successfulDeals;
  ProductType? productType;

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
      successfulDeals: json["successful_deals"] ?? 0,
      productType: json["product_type"] == null
          ? null
          : ProductType.fromJson(json["product_type"]));

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
        "successful_deals": successfulDeals,
        "product_type": productType
      };
}
