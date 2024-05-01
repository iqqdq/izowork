// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/request/news_comment_request.dart';
import 'package:izowork/entities/response/news.dart';
import 'package:izowork/entities/response/news_comment.dart';
import 'package:izowork/repositories/news_repository.dart';
import 'package:izowork/screens/profile/profile_screen.dart';

class NewsCommentsViewModel with ChangeNotifier {
  final News news;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<NewsComment> _comments = [];

  NewsComment? _comment;

  List<NewsComment> get comments => _comments;

  NewsComment? get comment => _comment;

  NewsCommentsViewModel(this.news) {
    getNewsComments(
      pagination: Pagination(offset: 0, size: 50),
      search: '',
      id: news.id,
    );
  }

  // MARK: -
  // MARK: - API CALL

  Future getNewsComments(
      {required Pagination pagination,
      required String search,
      required String id}) async {
    if (pagination.offset == 0) {
      loadingStatus = LoadingStatus.searching;
      _comments.clear();

      Future.delayed(Duration.zero, () async {
        notifyListeners();
      });
    }
    await NewsRepository()
        .getComments(pagination: pagination, search: search, id: id)
        .then((response) => {
              if (response is List<NewsComment>)
                {
                  if (_comments.isEmpty)
                    {
                      response.forEach((comment) {
                        _comments.add(comment);
                      })
                    }
                  else
                    {
                      response.forEach((newComment) {
                        bool found = false;

                        _comments.forEach((comment) {
                          if (newComment.id == comment.id) {
                            found = true;
                          }
                        });

                        if (!found) {
                          _comments.add(newComment);
                        }
                      })
                    },
                  loadingStatus = LoadingStatus.completed
                }
              else
                loadingStatus = LoadingStatus.error,
              notifyListeners()
            });
  }

  Future createNewsComment(BuildContext context, String comment) async {
    await NewsRepository()
        .createNewsComment(
            NewsCommentRequest(comment: comment, newsId: news.id))
        .then((response) => {
              if (response is NewsComment)
                {
                  _comment = response,
                  _comments.add(response),
                  loadingStatus = LoadingStatus.completed
                }
              else
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
                }
            })
        .whenComplete(() => notifyListeners());
  }

  // MARK: -
  // MARK: - PUSH

  void showProfileScreen(BuildContext context, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileScreenWidget(
                  isMine: false,
                  user: _comments[index].user,
                  onPop: (user) => null,
                )));
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void clearComment() {
    _comment = null;
  }
}
