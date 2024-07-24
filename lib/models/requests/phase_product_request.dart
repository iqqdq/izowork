class PhaseProductRequest {
  PhaseProductRequest({
    this.count,
    required this.phaseId,
    this.productId,
    this.termInDays,
  });

  int? count;
  String phaseId;
  String? productId;
  int? termInDays;

  Map<String, dynamic> toJson() => {
        "count": count,
        "phase_id": phaseId,
        "product_id": productId,
        "term_in_days": termInDays,
      };
}
