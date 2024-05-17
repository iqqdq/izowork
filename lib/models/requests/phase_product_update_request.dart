import 'dart:convert';

String phaseProductUpdateRequestToJson(PhaseProductUpdateRequest data) =>
    json.encode(data.toJson());

class PhaseProductUpdateRequest {
  PhaseProductUpdateRequest({
    this.count,
    required this.id,
    required this.phaseId,
    this.productId,
    this.termInDays,
  });

  String id;
  String phaseId;
  int? count;
  String? productId;
  int? termInDays;

  Map<String, dynamic> toJson() => {
        "count": count,
        "id": id,
        "phase_id": phaseId,
        "product_id": productId,
        "term_in_days": termInDays,
      };
}
