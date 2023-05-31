import 'dart:convert';

String companyRequestToJson(CompanyRequest data) => json.encode(data.toJson());

class CompanyRequest {
  CompanyRequest(
      {this.id,
      required this.address,
      this.description,
      this.details,
      this.email,
      required this.name,
      required this.phone,
      this.type,
      this.productTypeId});

  String? id;
  String address;
  String? description;
  String? details;
  String? email;
  String name;
  String phone;
  String? type;
  String? productTypeId;

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address,
        "description": description,
        "details": details,
        "email": email,
        "name": name,
        "phone": phone,
        "type": type,
        "product_type_id": productTypeId
      };
}
