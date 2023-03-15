// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/response/news.dart';
import 'package:izowork/repositories/news_repository.dart';
import 'package:izowork/screens/news/news_filter_sheet/news_filter_page_view_widget.dart';
import 'package:izowork/screens/news_comments/news_comments_screen.dart';
import 'package:izowork/screens/news_creation/news_creation_screen.dart';
import 'package:izowork/screens/news_page/news_page_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class NewsViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<News> _news = [];

  List<News> get news {
    return _news;
  }

  NewsViewModel() {
    getDealList(pagination: Pagination(offset: 0, size: 50), search: '');
  }

  // MARK: -
  // MARK: - API CALL

  Future getDealList(
      {required Pagination pagination, required String search}) async {
    if (pagination.offset == 0) {
      loadingStatus = LoadingStatus.searching;
      _news.clear();

      Future.delayed(Duration.zero, () async {
        notifyListeners();
      });
    }
    await NewsRepository()
        .getNews(
          pagination: pagination, search: search,
          //  params: _newsFilter?.params
        )
        .then((response) => {
              if (response is List<News>)
                {
                  if (_news.isEmpty)
                    {
                      response.forEach((news) {
                        _news.add(news);
                      })
                    }
                  else
                    {
                      response.forEach((newest) {
                        bool found = false;

                        _news.forEach((news) {
                          if (newest.id == news.id) {
                            found = true;
                          }
                        });

                        if (!found) {
                          _news.add(newest);
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

  // MARK: -
  // MARK: - PUSH

  void showContactsFilterSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => NewsFilterPageViewWidget(
            onApplyTap: () => Navigator.pop(context), onResetTap: () => {}));
  }

  void showNewsCreationScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const NewsCreationScreenWidget()));
  }

  void showNewsPageScreen(BuildContext context, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewsPageScreenWidget(
                news: _news[index], tag: index.toString())));
  }

  void showNewsCommentsScreen(BuildContext context, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NewsCommentsScreenWidget(tag: index.toString())));
  }
}
