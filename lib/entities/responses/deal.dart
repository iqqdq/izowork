import 'package:izowork/entities/responses/responses.dart';

class Deal {
  Deal(
      {this.comment,
      this.companyId,
      required this.createdAt,
      required this.files,
      required this.finishAt,
      required this.id,
      required this.number,
      this.objectId,
      required this.dealProducts,
      this.responsibleId,
      required this.closed,
      this.company,
      this.responsible,
      this.object,
      this.dealStage,
      this.phaseId});

  String? comment;
  String? companyId;
  String createdAt;
  List<Document> files;
  String finishAt;
  String id;
  int number;
  String? objectId;
  List<DealProduct> dealProducts;
  String? responsibleId;
  bool closed;
  Company? company;
  User? responsible;
  MapObject? object;
  DealStage? dealStage;
  String? phaseId;

  factory Deal.fromJson(Map<String, dynamic> json) => Deal(
      comment: json["comment"],
      companyId: json["company_id"],
      createdAt: json["created_at"],
      files: json["files"] == null
          ? []
          : List<Document>.from(json["files"].map((x) => Document.fromJson(x))),
      finishAt: json["finish_at"],
      id: json["id"],
      number: json["number"],
      objectId: json["object_id"],
      dealProducts: json["products"] == null
          ? []
          : List<DealProduct>.from(
              json["products"].map((x) => DealProduct.fromJson(x))),
      responsibleId: json["responsible_id"],
      closed: json["closed"],
      company:
          json["company"] == null ? null : Company.fromJson(json["company"]),
      responsible: json["responsible"] == null
          ? null
          : User.fromJson(json["responsible"]),
      object:
          json["object"] == null ? null : MapObject.fromJson(json["object"]),
      dealStage: json["deal_stage"] == null
          ? null
          : DealStage.fromJson(json["deal_stage"]),
      phaseId: json["phase_id"]);
}

class DealProduct {
  DealProduct({
    required this.count,
    required this.dealId,
    required this.id,
    this.product,
    this.productId,
  });

  int count;
  String dealId;
  String id;
  Product? product;
  String? productId;

  factory DealProduct.fromJson(Map<String, dynamic> json) => DealProduct(
        count: json["count"],
        dealId: json["deal_id"],
        id: json["id"],
        product:
            json["product"] == null ? null : Product.fromJson(json["product"]),
        productId: json["product_id"],
      );
}
