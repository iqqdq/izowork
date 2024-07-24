class NewsCommentRequest {
  NewsCommentRequest({
    required this.comment,
    required this.newsId,
  });

  String comment;
  String newsId;

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "news_id": newsId,
      };
}
