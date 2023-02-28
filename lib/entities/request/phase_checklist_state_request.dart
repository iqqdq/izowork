// To parse this JSON data, do
//
//     final phaseChecklistStateRequest = phaseChecklistStateRequestFromJson(jsonString);

import 'dart:convert';

PhaseChecklistStateRequest phaseChecklistStateRequestFromJson(String str) =>
    PhaseChecklistStateRequest.fromJson(json.decode(str));

String phaseChecklistStateRequestToJson(PhaseChecklistStateRequest data) =>
    json.encode(data.toJson());

class PhaseChecklistStateRequest {
  PhaseChecklistStateRequest({
    required this.id,
    required this.state,
  });

  String id;
  String state;

  factory PhaseChecklistStateRequest.fromJson(Map<String, dynamic> json) =>
      PhaseChecklistStateRequest(
        id: json["id"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "state": state,
      };
}
