import 'dart:convert';

String dealProductRequestToJson(DealProductRequest data) =>
    json.encode(data.toJson());

class DealProductRequest {
  DealProductRequest({
    required this.count,
    this.dealId,
    this.id,
    this.productId,
  });

  int count;
  String? dealId;
  String? id;
  String? productId;

  Map<String, dynamic> toJson() => {
        "count": count,
        "deal_id": dealId,
        "id": id,
        "product_id": productId,
      };
}
