import 'package:izowork/models/models.dart';

class NewsComment {
  NewsComment({
    required this.comment,
    required this.createdAt,
    required this.id,
    required this.newsId,
    required this.user,
    required this.userId,
  });

  String comment;
  DateTime createdAt;
  String id;
  String newsId;
  User user;
  String userId;

  factory NewsComment.fromJson(Map<String, dynamic> json) => NewsComment(
        comment: json["comment"],
        createdAt: DateTime.parse(json["created_at"]).toUtc().toLocal(),
        id: json["id"],
        newsId: json["news_id"],
        user: User.fromJson(json["user"]),
        userId: json["user_id"],
      );
}
