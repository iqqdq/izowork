import 'dart:convert';
import 'package:izowork/entities/response/company.dart';
import 'package:izowork/entities/response/product_type.dart';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.unit,
    this.image,
    required this.company,
    required this.companyId,
    required this.productType,
    required this.productTypeId,
  });

  String id;
  String name;
  num price;
  String unit;
  String? image;
  Company company;
  String companyId;
  ProductType productType;
  String productTypeId;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        unit: json["unit"],
        image: json["image"],
        company: Company.fromJson(json["company"]),
        companyId: json["company_id"],
        productType: ProductType.fromJson(json["product_type"]),
        productTypeId: json["product_type_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "unit": unit,
        "image": image,
        "company": company.toJson(),
        "company_id": companyId,
        "product_type": productType.toJson(),
        "product_type_id": productTypeId,
      };
}