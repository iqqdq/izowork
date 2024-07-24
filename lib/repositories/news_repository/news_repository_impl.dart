import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/services/services.dart';

import 'news_repository_interface.dart';

class NewsRepositoryImpl implements NewsRepositoryInterface {
  @override
  Future<dynamic> getNews({
    required Pagination pagination,
    required String search,
    List<String>? params,
  }) async {
    var url = newsUrl + '?offset=${pagination.offset}&limit=${pagination.size}';

    if (search.isNotEmpty) {
      url += '&q=$search';
    }

    if (params != null) {
      for (var element in params) {
        url += element;
      }
    }

    dynamic json = await sl<WebServiceInterface>().get(url);
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

  @override
  Future<dynamic> getNewsOne(String id) async {
    dynamic json = await sl<WebServiceInterface>().get(newsOneUrl + '?id=$id');

    try {
      return News.fromJson(json["news"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> createNews(NewsRequest newsRequest) async {
    dynamic json = await sl<WebServiceInterface>().post(
      newsCreateUrl,
      newsRequest.toJson(),
    );

    try {
      return News.fromJson(json["news"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> getComments(
      {required Pagination pagination,
      required String search,
      required String id}) async {
    var url = newsCommentUrl +
        '?offset=${pagination.offset}&limit=${pagination.size}&news_id=$id';

    if (search.isNotEmpty) {
      url += '&q=$search';
    }

    dynamic json = await sl<WebServiceInterface>().get(url);
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

  @override
  Future<dynamic> createNewsComment(
      NewsCommentRequest newsCommentRequest) async {
    dynamic json = await sl<WebServiceInterface>().post(
      newsCommentUrl,
      newsCommentRequest.toJson(),
    );

    try {
      return NewsComment.fromJson(json["comment"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> addNewsFile(NewsFileRequest newsFileRequest) async {
    dynamic json = await sl<WebServiceInterface>().postFormData(
      newsFileUrl,
      await newsFileRequest.toFormData(),
    );

    try {
      return NewsFile.fromJson(json["file"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }
}
