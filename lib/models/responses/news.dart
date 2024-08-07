import 'package:izowork/models/models.dart';

class News {
  News(
      {required this.id,
      required this.createdAt,
      required this.name,
      required this.description,
      required this.important,
      required this.commentsTotal,
      this.userId,
      this.user,
      required this.files,
      this.lastComment});

  String id;
  DateTime createdAt;
  String name;
  String description;
  bool important;
  int commentsTotal;
  String? userId;
  User? user;
  List<NewsFile> files;
  NewsComment? lastComment;

  factory News.fromJson(Map<String, dynamic> json) => News(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]).toUtc().toLocal(),
        name: json["name"],
        description: json["description"],
        important: json["important"],
        commentsTotal: json["comments_total"],
        userId: json["user_id"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
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
