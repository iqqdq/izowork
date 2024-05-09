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
