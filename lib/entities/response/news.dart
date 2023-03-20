import 'dart:convert';

import 'package:izowork/entities/response/news_comment.dart';
import 'package:izowork/entities/response/user.dart';

News newsFromJson(String str) => News.fromJson(json.decode(str));

class News {
  News(
      {required this.id,
      required this.createdAt,
      required this.name,
      required this.description,
      required this.important,
      required this.commentsTotal,
      required this.userId,
      required this.user,
      required this.files,
      this.lastComment});

  String id;
  DateTime createdAt;
  String name;
  String description;
  bool important;
  int commentsTotal;
  String userId;
  User user;
  List<NewsFile> files;
  NewsComment? lastComment;

  factory News.fromJson(Map<String, dynamic> json) => News(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        name: json["name"],
        description: json["description"],
        important: json["important"],
        commentsTotal: json["comments_total"],
        userId: json["user_id"],
        user: User.fromJson(json["user"]),
        files: json["files"] == null
            ? []
            : List<NewsFile>.from(
                json["files"].map((x) => NewsFile.fromJson(x))),
        lastComment: json["last_comment"] == null
            ? null
            : NewsComment.fromJson(json["last_comment"]),
      );
}

class NewsFile {
  NewsFile({
    required this.id,
    required this.filename,
    required this.newsId,
  });

  String id;
  String filename;
  String newsId;

  factory NewsFile.fromJson(Map<String, dynamic> json) => NewsFile(
        id: json["id"],
        filename: json["filename"],
        newsId: json["news_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "filename": filename,
        "news_id": newsId,
      };
}
