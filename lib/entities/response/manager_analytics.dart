import 'dart:convert';
import 'package:izowork/entities/response/user.dart';

ManagerAnalytics managerAnalyticsFromJson(String str) =>
    ManagerAnalytics.fromJson(json.decode(str));

String managerAnalyticsToJson(ManagerAnalytics data) =>
    json.encode(data.toJson());

class ManagerAnalytics {
  ManagerAnalytics({
    required this.users,
    required this.efficiency,
  });

  List<User> users;
  List<int> efficiency;

  factory ManagerAnalytics.fromJson(Map<String, dynamic> json) =>
      ManagerAnalytics(
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
        efficiency: List<int>.from(json["efficiency"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
        "efficiency": List<dynamic>.from(efficiency.map((x) => x)),
      };
}
