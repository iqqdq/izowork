import 'dart:convert';

ProductType productTypeFromJson(String str) =>
    ProductType.fromJson(json.decode(str));

String productTypeToJson(ProductType data) => json.encode(data.toJson());

class ProductType {
  ProductType({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory ProductType.fromJson(Map<String, dynamic> json) => ProductType(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
