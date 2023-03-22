import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/request/news_comment_request.dart';
import 'package:izowork/entities/request/news_file_request.dart';
import 'package:izowork/entities/request/news_request.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/news.dart';
import 'package:izowork/entities/response/news_comment.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/services/web_service.dart';

class NewsRepository {
  Future<dynamic> getNews(
      {required Pagination pagination,
      required String search,
      List<String>? params}) async {
    var url = newsUrl + '?offset=${pagination.offset}&limit=${pagination.size}';

    if (search.isNotEmpty) {
      url += '&q=$search';
    }

    if (params != null) {
      for (var element in params) {
        url += element;
      }
    }

    dynamic json = await WebService().get(url);
    List<News> news = [];

    try {
      json['news'].forEach((element) {
        news.add(News.fromJson(element));
      });
      return news;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> createNews(NewsRequest newsRequest) async {
    dynamic json = await WebService().post(newsCreateUrl, newsRequest);

    try {
      return News.fromJson(json["news"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> getComments(
      {required Pagination pagination,
      required String search,
      required String id}) async {
    var url = newsCommentUrl +
        '?offset=${pagination.offset}&limit=${pagination.size}&news_id=$id';

    if (search.isNotEmpty) {
      url += '&q=$search';
    }

    dynamic json = await WebService().get(url);
    List<NewsComment> comments = [];

    try {
      json['comments'].forEach((element) {
        comments.add(NewsComment.fromJson(element));
      });
      return comments;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> createNewsComment(
      NewsCommentRequest newsCommentRequest) async {
    dynamic json = await WebService().post(newsCommentUrl, newsCommentRequest);

    try {
      return NewsComment.fromJson(json["comment"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> addNewsFile(NewsFileRequest newsFileRequest) async {
    dynamic json = await WebService()
        .postFormData(newsFileUrl, await newsFileRequest.toFormData());

    try {
      return NewsFile.fromJson(json["file"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }
}
