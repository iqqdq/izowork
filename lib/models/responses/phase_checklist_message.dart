import 'package:izowork/models/models.dart';

class PhaseChecklistMessagesResponse {
  int count;
  final List<PhaseChecklistMessage> messages;

  PhaseChecklistMessagesResponse({
    required this.count,
    required this.messages,
  });

  factory PhaseChecklistMessagesResponse.fromJson(Map<String, dynamic> json) =>
      PhaseChecklistMessagesResponse(
        count: json["count"],
        messages: List<PhaseChecklistMessage>.from(
            json["messages"].map((x) => PhaseChecklistMessage.fromJson(x))),
      );
}

class PhaseChecklistMessage {
  final String body;
  final String checklistId;
  final DateTime createdAt;
  final String id;
  final User user;

  PhaseChecklistMessage({
    required this.body,
    required this.checklistId,
    required this.createdAt,
    required this.id,
    required this.user,
  });

  factory PhaseChecklistMessage.fromJson(Map<String, dynamic> json) =>
      PhaseChecklistMessage(
        body: json["body"],
        checklistId: json["checklist_id"],
        createdAt: DateTime.parse(json["created_at"]).toUtc().toLocal(),
        id: json["id"],
        user: User.fromJson(json["user"]),
      );
}
