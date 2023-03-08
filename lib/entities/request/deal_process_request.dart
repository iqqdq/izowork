import 'dart:convert';

String dealProcessURequestToJson(DealProcessRequest data) =>
    json.encode(data.toJson());

class DealProcessRequest {
  DealProcessRequest({
    required this.hidden,
    required this.id,
    required this.status,
  });

  bool hidden;
  String id;
  String status;

  Map<String, dynamic> toJson() => {
        "hidden": hidden,
        "id": id,
        "status": status,
      };
}
