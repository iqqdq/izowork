class ContactRequest {
  ContactRequest({
    this.companyId,
    this.email,
    this.id,
    this.name,
    this.post,
    this.phone,
    this.social,
  });

  String? companyId;
  String? email;
  String? id;
  String? name;
  String? post;
  String? phone;
  List<String>? social;

  Map<String, dynamic> toJson() => {
        "company_id": companyId,
        "email": email,
        "id": id,
        "name": name,
        "post": post,
        "phone": phone,
        "social":
            social == null ? [] : List<dynamic>.from(social!.map((x) => x)),
      };
}
