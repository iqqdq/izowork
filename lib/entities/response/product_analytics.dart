import 'dart:convert';

ProductAnalytics productAnalyticsFromJson(String str) =>
    ProductAnalytics.fromJson(json.decode(str));

String productAnalyticsToJson(ProductAnalytics data) =>
    json.encode(data.toJson());

class ProductAnalytics {
  ProductAnalytics({
    required this.labels,
    required this.pledged,
    required this.sold,
  });

  List<String> labels;
  List<int> pledged;
  List<int> sold;

  factory ProductAnalytics.fromJson(Map<String, dynamic> json) =>
      ProductAnalytics(
        labels: List<String>.from(json["labels"].map((x) => x)),
        pledged: List<int>.from(json["pledged"].map((x) => x)),
        sold: List<int>.from(json["sold"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "labels": List<dynamic>.from(labels.map((x) => x)),
        "pledged": List<dynamic>.from(pledged.map((x) => x)),
        "sold": List<dynamic>.from(sold.map((x) => x)),
      };
}
