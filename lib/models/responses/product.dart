import 'package:izowork/models/models.dart';

class Product {
  Product({
    required this.id,
    required this.name,
    this.price,
    this.unit,
    this.image,
    this.company,
    this.companyId,
    this.productType,
    this.productTypeId,
  });

  String id;
  String name;
  num? price;
  String? unit;
  String? image;
  Company? company;
  String? companyId;
  ProductType? productType;
  String? productTypeId;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        unit: json["unit"],
        image: json["image"],
        company:
            json["company"] == null ? null : Company.fromJson(json["company"]),
        companyId: json["company_id"],
        productType: json["product_type"] == null
            ? null
            : ProductType.fromJson(json["product_type"]),
        productTypeId: json["product_type_id"],
      );
}
