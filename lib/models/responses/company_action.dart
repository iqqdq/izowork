import 'package:izowork/models/models.dart';

class CompanyAction {
  final String companyId;
  final DateTime? createdAt;
  final String? description;
  final String id;
  final User? user;

  CompanyAction({
    required this.companyId,
    required this.createdAt,
    required this.description,
    required this.id,
    required this.user,
  });

  factory CompanyAction.fromJson(Map<String, dynamic> json) => CompanyAction(
        companyId: json["company_id"],
        createdAt: DateTime.parse(json["created_at"]).toUtc().toLocal(),
        description: json["description"],
        id: json["id"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "company_id": companyId,
        "created_at": createdAt,
        "description": description,
        "id": id,
        "user": user?.toJson(),
      };
}
