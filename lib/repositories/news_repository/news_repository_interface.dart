import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';

abstract class NewsRepositoryInterface {
  Future<dynamic> getNews({
    required Pagination pagination,
    required String search,
    List<String>? params,
  });

  Future<dynamic> getNewsOne(String id);

  Future<dynamic> createNews(NewsRequest newsRequest);

  Future<dynamic> getComments({
    required Pagination pagination,
    required String search,
    required String id,
  });

  Future<dynamic> createNewsComment(NewsCommentRequest newsCommentRequest);

  Future<dynamic> addNewsFile(NewsFileRequest newsFileRequest);
}
