import 'dart:convert';

NotificationEntity notificationFromJson(String str) =>
    NotificationEntity.fromJson(json.decode(str));

class NotificationEntity {
  NotificationEntity({
    required this.id,
    required this.text,
    required this.userId,
    required this.createdAt,
    required this.type,
    required this.metadata,
    required this.read,
  });

  String id;
  String text;
  String userId;
  DateTime createdAt;
  String type;
  Metadata metadata;
  bool read;

  factory NotificationEntity.fromJson(Map<String, dynamic> json) =>
      NotificationEntity(
        id: json["id"],
        text: json["text"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        type: json["type"],
        metadata: Metadata.fromJson(json["metadata"]),
        read: json["read"],
      );
}

class Metadata {
  Metadata(
      {this.objectId, this.dealId, this.taskId, this.newsId, this.phaseId});

  String? objectId;
  String? dealId;
  String? taskId;
  String? newsId;
  String? phaseId;

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
      objectId: json["object_id"],
      dealId: json["deal_id"],
      taskId: json["task_id"],
      newsId: json["news_id"],
      phaseId: json["phase_id"]);
}
