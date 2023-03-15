import 'dart:convert';

import 'package:izowork/entities/response/user.dart';

News newsFromJson(String str) => News.fromJson(json.decode(str));

class News {
  News({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.description,
    required this.important,
    required this.userId,
    required this.user,
    required this.files,
  });

  String id;
  DateTime createdAt;
  String name;
  String description;
  bool important;
  String userId;
  User user;
  List<NewsFile> files;

  factory News.fromJson(Map<String, dynamic> json) => News(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        name: json["name"],
        description: json["description"],
        important: json["important"],
        userId: json["user_id"],
        user: User.fromJson(json["user"]),
        files: json["files"] == null
            ? []
            : List<NewsFile>.from(
                json["files"].map((x) => NewsFile.fromJson(x))),
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
