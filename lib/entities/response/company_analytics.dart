import 'dart:convert';

CompanyAnalytics companyAnalyticsFromJson(String str) =>
    CompanyAnalytics.fromJson(json.decode(str));

String companyAnalyticsToJson(CompanyAnalytics data) =>
    json.encode(data.toJson());

class CompanyAnalytics {
  CompanyAnalytics({
    required this.labels,
    required this.data,
  });

  List<String> labels;
  List<int> data;

  factory CompanyAnalytics.fromJson(Map<String, dynamic> json) =>
      CompanyAnalytics(
        labels: List<String>.from(json["labels"].map((x) => x)),
        data: List<int>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "labels": List<dynamic>.from(labels.map((x) => x)),
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}
