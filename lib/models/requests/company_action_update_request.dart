class CompanyActionUpdateRequest {
  final String companyId;
  final String description;
  final String? id;

  CompanyActionUpdateRequest({
    required this.companyId,
    required this.description,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
        "company_id": companyId,
        "description": description,
        "id": id,
      };
}
