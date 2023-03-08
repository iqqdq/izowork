import 'dart:convert';

DealProcess dealProcessFromJson(String str) =>
    DealProcess.fromJson(json.decode(str));

String dealProcessToJson(DealProcess data) => json.encode(data.toJson());

class DealProcess {
  DealProcess({
    required this.confirmations,
    required this.dealStageId,
    required this.hidden,
    required this.id,
    required this.name,
    required this.needConfirmations,
    required this.position,
    required this.status,
    required this.statuses,
    required this.weight,
  });

  Confirmations confirmations;
  String dealStageId;
  bool hidden;
  String id;
  String name;
  List<String> needConfirmations;
  int position;
  String status;
  List<String> statuses;
  int weight;

  factory DealProcess.fromJson(Map<String, dynamic> json) => DealProcess(
        confirmations: Confirmations.fromJson(json["confirmations"]),
        dealStageId: json["deal_stage_id"],
        hidden: json["hidden"],
        id: json["id"],
        name: json["name"],
        needConfirmations:
            List<String>.from(json["need_confirmations"].map((x) => x)),
        position: json["position"],
        status: json["status"],
        statuses: List<String>.from(json["statuses"].map((x) => x)),
        weight: json["weight"],
      );

  Map<String, dynamic> toJson() => {
        "confirmations": confirmations.toJson(),
        "deal_stage_id": dealStageId,
        "hidden": hidden,
        "id": id,
        "name": name,
        "need_confirmations":
            List<dynamic>.from(needConfirmations.map((x) => x)),
        "position": position,
        "status": status,
        "statuses": List<dynamic>.from(statuses.map((x) => x)),
        "weight": weight,
      };
}

class Confirmations {
  Confirmations({
    required this.additionalProp1,
  });

  AdditionalProp1 additionalProp1;

  factory Confirmations.fromJson(Map<String, dynamic> json) => Confirmations(
        additionalProp1: AdditionalProp1.fromJson(json["additionalProp1"]),
      );

  Map<String, dynamic> toJson() => {
        "additionalProp1": additionalProp1.toJson(),
      };
}

class AdditionalProp1 {
  AdditionalProp1();

  factory AdditionalProp1.fromJson(Map<String, dynamic> json) =>
      AdditionalProp1();

  Map<String, dynamic> toJson() => {};
}
