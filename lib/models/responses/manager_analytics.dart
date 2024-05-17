import 'package:izowork/models/models.dart';

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
        efficiency: List<int>.from(json["efficiency"].map((x) {
          if (x is int && x == 0) {
            return x;
          }
          if (x is int && x == 1) {
            return 100;
          }
          double decimalPart = x * 100;
          int result = decimalPart.toInt();

          return result;
        })),
      );

  Map<String, dynamic> toJson() => {
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
        "efficiency": List<dynamic>.from(efficiency.map((x) => x)),
      };
}
