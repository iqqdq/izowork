import 'dart:convert';

String dealProcessInfoRequestToJson(DealProcessInfoRequest data) =>
    json.encode(data.toJson());

class DealProcessInfoRequest {
  DealProcessInfoRequest({
    this.id,
    this.dealStageProcessId,
    required this.description,
  });

  String? id;
  String? dealStageProcessId;
  String description;

  Map<String, dynamic> toJson() => {
        "id": id,
        "deal_stage_process_id": dealStageProcessId,
        "description": description,
      };
}
