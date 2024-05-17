import 'package:izowork/models/models.dart';

class PhaseProduct {
  PhaseProduct(
      {required this.bought,
      required this.count,
      required this.id,
      required this.phaseId,
      this.productId,
      this.termInDays,
      this.product});

  int bought;
  int count;
  String id;
  String phaseId;
  String? productId;
  int? termInDays;
  Product? product;

  factory PhaseProduct.fromJson(Map<String, dynamic> json) => PhaseProduct(
      bought: json["bought"] ?? 0,
      count: json["count"] ?? 0,
      id: json["id"],
      phaseId: json["phase_id"],
      productId: json["product_id"],
      termInDays: json["term_in_days"],
      product:
          json["product"] == null ? null : Product.fromJson(json["product"]));
}
