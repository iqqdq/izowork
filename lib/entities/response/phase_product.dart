import 'dart:convert';
import 'package:izowork/entities/response/product.dart';

PhaseProduct phaseProductFromJson(String str) =>
    PhaseProduct.fromJson(json.decode(str));

class PhaseProduct {
  PhaseProduct(
      {this.count,
      required this.id,
      required this.phaseId,
      this.productId,
      this.termInDays,
      this.product});

  int? count;
  String id;
  String phaseId;
  String? productId;
  int? termInDays;
  Product? product;

  factory PhaseProduct.fromJson(Map<String, dynamic> json) => PhaseProduct(
      count: json["count"],
      id: json["id"],
      phaseId: json["phase_id"],
      productId: json["product_id"],
      termInDays: json["term_in_days"],
      product:
          json["product"] == null ? null : Product.fromJson(json["product"]));
}
