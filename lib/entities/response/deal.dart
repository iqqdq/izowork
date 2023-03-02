import 'dart:convert';
import 'package:izowork/entities/response/document.dart';
import 'package:izowork/entities/response/product.dart';

Deal dealFromJson(String str) => Deal.fromJson(json.decode(str));

class Deal {
  Deal({
    this.comment,
    this.companyId,
    required this.createdAt,
    required this.files,
    required this.finishAt,
    required this.id,
    required this.number,
    this.objectId,
    required this.dealProducts,
    this.responsibleId,
  });

  String? comment;
  String? companyId;
  String createdAt;
  List<Document> files;
  String finishAt;
  String id;
  int number;
  String? objectId;
  List<DealProduct> dealProducts;
  String? responsibleId;

  factory Deal.fromJson(Map<String, dynamic> json) => Deal(
        comment: json["comment"],
        companyId: json["company_id"],
        createdAt: json["created_at"],
        files: json["files"] == null
            ? []
            : List<Document>.from(
                json["files"].map((x) => Document.fromJson(x))),
        finishAt: json["finish_at"],
        id: json["id"],
        number: json["number"],
        objectId: json["object_id"],
        dealProducts: json["products"] == null
            ? []
            : List<DealProduct>.from(
                json["products"].map((x) => DealProduct.fromJson(x))),
        responsibleId: json["responsible_id"],
      );
}

class DealProduct {
  DealProduct({
    this.count,
    this.dealId,
    required this.id,
    this.product,
    this.productId,
  });

  int? count;
  String? dealId;
  String id;
  Product? product;
  String? productId;

  factory DealProduct.fromJson(Map<String, dynamic> json) => DealProduct(
        count: json["count"],
        dealId: json["deal_id"],
        id: json["id"],
        product:
            json["product"] == null ? null : Product.fromJson(json["product"]),
        productId: json["product_id"],
      );
}
