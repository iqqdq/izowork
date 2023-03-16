import 'dart:convert';

import 'package:izowork/entities/response/user.dart';

NewsComment newsCommentFromJson(String str) =>
    NewsComment.fromJson(json.decode(str));

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
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
        newsId: json["news_id"],
        user: User.fromJson(json["user"]),
        userId: json["user_id"],
      );
}
