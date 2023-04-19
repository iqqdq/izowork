import 'dart:convert';

ObjectAnalytics objectAnalyticsFromJson(String str) =>
    ObjectAnalytics.fromJson(json.decode(str));

String objectAnalyticsToJson(ObjectAnalytics data) =>
    json.encode(data.toJson());

class ObjectAnalytics {
  ObjectAnalytics({
    required this.labels,
    required this.data,
  });

  List<String> labels;
  List<int> data;

  factory ObjectAnalytics.fromJson(Map<String, dynamic> json) =>
      ObjectAnalytics(
        labels: List<String>.from(json["labels"].map((x) => x)),
        data: List<int>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "labels": List<dynamic>.from(labels.map((x) => x)),
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}
