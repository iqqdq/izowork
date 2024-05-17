import 'dart:convert';

ReadNotificationRequest readNotificationRequestFromJson(String str) =>
    ReadNotificationRequest.fromJson(json.decode(str));

String readNotificationRequestToJson(ReadNotificationRequest data) =>
    json.encode(data.toJson());

class ReadNotificationRequest {
  ReadNotificationRequest({
    required this.id,
  });

  String id;

  factory ReadNotificationRequest.fromJson(Map<String, dynamic> json) =>
      ReadNotificationRequest(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
