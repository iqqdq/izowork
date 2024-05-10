import 'package:izowork/entities/responses/responses.dart';

class Company {
  Company({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    this.lat,
    this.long,
    this.email,
    this.details,
    this.description,
    this.manager,
    this.image,
    required this.type,
    required this.successfulDeals,
    this.productType,
    required this.contacts,
  });

  String id;
  String name;
  String? address;
  String? phone;
  double? lat;
  double? long;
  String? email;
  String? details;
  String? description;
  User? manager;
  String? image;
  String type;
  int? successfulDeals;
  ProductType? productType;
  List<Contact> contacts;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        phone: json["phone"],
        lat: json["lat"] == 0 ? null : json["lat"],
        long: json["long"] == 0 ? null : json["long"],
        email: json["email"] ?? '-',
        details: json["details"] ?? '-',
        description: json["description"] ?? '-',
        manager:
            json["manager"] == null ? null : User.fromJson(json["manager"]),
        image: json["image"],
        type: json["type"],
        successfulDeals: json["successful_deals"] ?? 0,
        productType: json["product_type"] == null
            ? null
            : ProductType.fromJson(json["product_type"]),
        contacts: json["contacts"] == null
            ? []
            : List<Contact>.from(
                json["contacts"].map((x) => Contact.fromJson(x))),
      );
}
