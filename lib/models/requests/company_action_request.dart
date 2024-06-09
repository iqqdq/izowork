class CompanyActionRequest {
  final String companyId;
  final String description;
  final String? userId;

  CompanyActionRequest({
    required this.companyId,
    required this.description,
    required this.userId,
  });

  factory CompanyActionRequest.fromJson(Map<String, dynamic> json) =>
      CompanyActionRequest(
        companyId: json["company_id"],
        description: json["description"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "company_id": companyId,
        "description": description,
        "user_id": userId,
      };
}
