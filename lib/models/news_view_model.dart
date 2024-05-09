// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/screens/news/news_filter_sheet/news_filter_page_view_screen.dart';
import 'package:izowork/screens/news/news_filter_sheet/news_filter_page_view_screen_body.dart';
import 'package:izowork/screens/news_comments/news_comments_screen.dart';
import 'package:izowork/screens/news_create/news_create_screen.dart';
import 'package:izowork/screens/news_page/news_page_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class NewsViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<News> _news = [];

  NewsFilter? _newsFilter;

  List<News> get news => _news;

  NewsFilter? get newsFilter => _newsFilter;

  NewsViewModel() {
    getNews(
      pagination: Pagination(offset: 0, size: 50),
      search: '',
    );
  }

  // MARK: -
  // MARK: - API CALL

  Future getNews({
    required Pagination pagination,
    required String search,
  }) async {
    if (pagination.offset == 0) {
      loadingStatus = LoadingStatus.searching;
      _news.clear();

      Future.delayed(Duration.zero, () async {
        notifyListeners();
      });
    }
    await NewsRepository()
        .getNews(
          pagination: pagination,
          search: search,
          params: _newsFilter?.params,
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
            })
        .whenComplete(() => notifyListeners());
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void resetFilter() => _newsFilter = null;

  // MARK: -
  // MARK: - PUSH

  void showNewsFilterSheet(
    BuildContext context,
    Function() onFilter,
  ) =>
      showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => NewsFilterPageViewScreenWidget(
            newsFilter: _newsFilter,
            onPop: (newsFilter) => {
                  if (newsFilter == null)
                    {
                      // CLEAR
                      resetFilter(),
                      onFilter()
                    }
                  else
                    {
                      // FILTER
                      _newsFilter = newsFilter,
                      onFilter()
                    }
                }),
      );

  void showNewsCreationScreen(
    BuildContext context,
    Pagination pagination,
    String search,
  ) =>
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsCreateScreenWidget(
              onPop: (news) => {
                    pagination.size += 1,
                    getNews(
                      pagination: pagination,
                      search: search,
                    ),
                    Toast().showTopToast(
                      context,
                      Titles.newsWasAdded,
                    )
                  }),
        ),
      );

  void showNewsPageScreen(
    BuildContext context,
    int index,
  ) =>
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NewsPageScreenWidget(
                    news: _news[index],
                    tag: index.toString(),
                  )));

  void showNewsCommentsScreen(
    BuildContext context,
    int index,
  ) =>
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NewsCommentsScreenWidget(
                    tag: index.toString(),
                    news: _news[index],
                  )));
}
