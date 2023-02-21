import 'dart:convert';

CompanyType companyTypeFromJson(String str) =>
    CompanyType.fromJson(json.decode(str));

String companyTypeToJson(CompanyType data) => json.encode(data.toJson());

class CompanyType {
  CompanyType({
    required this.states,
  });

  List<String> states;

  factory CompanyType.fromJson(Map<String, dynamic> json) => CompanyType(
        states: List<String>.from(json["types"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "types": List<dynamic>.from(states.map((x) => x)),
      };
}
