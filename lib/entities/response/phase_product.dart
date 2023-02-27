import 'dart:convert';

String phaseProductToJson(PhaseProduct data) => json.encode(data.toJson());
PhaseProduct phaseProductFromJson(String str) =>
    PhaseProduct.fromJson(json.decode(str));

class PhaseProduct {
  PhaseProduct({
    this.count,
    required this.id,
    required this.phaseId,
    this.productId,
    this.termInDays,
  });

  int? count;
  String id;
  String phaseId;
  String? productId;
  int? termInDays;

  factory PhaseProduct.fromJson(Map<String, dynamic> json) => PhaseProduct(
        count: json["count"],
        id: json["id"],
        phaseId: json["phase_id"],
        productId: json["product_id"],
        termInDays: json["term_in_days"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "id": id,
        "phase_id": phaseId,
        "product_id": productId,
        "term_in_days": termInDays,
      };
}
