class DealProcess {
  DealProcess({
    this.confirmations,
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

  Map<String, bool>? confirmations;
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
        confirmations: json["confirmations"] == null
            ? null
            : Map.from(json["confirmations"]),
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
        "confirmations": confirmations,
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
  bool? accountant;
  bool? director;
  bool? logistician;
  bool? lawyer;
  bool? administrator;
  bool? manager;

  Confirmations({
    this.accountant,
    this.director,
    this.logistician,
    this.lawyer,
    this.administrator,
    this.manager,
  });

  factory Confirmations.fromJson(Map<String, dynamic> json) => Confirmations(
        accountant: json["ACCOUNTANT"],
        director: json["DIRECTOR"],
        logistician: json["LOGISTICIAN"],
        lawyer: json["LAWYER"],
        administrator: json["ADMINISTRATOR"],
        manager: json["MANAGER"],
      );
}
