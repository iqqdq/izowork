class CompanyActionRequest {
  final String companyId;
  final String description;
  final String? userId;

  CompanyActionRequest({
    required this.companyId,
    required this.description,
    required this.userId,
  });

  Map<String, dynamic> toJson() => {
        "company_id": companyId,
        "description": description,
        "user_id": userId,
      };
}
