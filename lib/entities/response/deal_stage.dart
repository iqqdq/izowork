import 'dart:convert';

import 'package:izowork/entities/response/deal_process.dart';

DealStage dealStageFromJson(String str) => DealStage.fromJson(json.decode(str));

String dealStageToJson(DealStage data) => json.encode(data.toJson());

class DealStage {
  DealStage(
      {required this.id,
      required this.defaultDealStageId,
      required this.dealId,
      required this.position,
      required this.name,
      required this.requiredActions,
      required this.actions,
      required this.locked,
      this.processes});

  String id;
  String defaultDealStageId;
  String dealId;
  int position;
  String name;
  int requiredActions;
  int actions;
  bool locked;
  List<DealProcess>? processes;

  factory DealStage.fromJson(Map<String, dynamic> json) => DealStage(
        id: json["id"],
        defaultDealStageId: json["default_deal_stage_id"],
        dealId: json["deal_id"],
        position: json["position"],
        name: json["name"],
        requiredActions: json["required_actions"],
        actions: json["actions"],
        locked: json["locked"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "default_deal_stage_id": defaultDealStageId,
        "deal_id": dealId,
        "position": position,
        "name": name,
        "required_actions": requiredActions,
        "actions": actions,
        "locked": locked,
      };
}
