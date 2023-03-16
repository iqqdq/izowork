// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/response/news.dart';
import 'package:izowork/repositories/news_repository.dart';
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

  List<News> get news {
    return _news;
  }

  NewsFilter? get newsFilter {
    return _newsFilter;
  }

  NewsViewModel() {
    getNews(pagination: Pagination(offset: 0, size: 50), search: '');
  }

  // MARK: -
  // MARK: - API CALL

  Future getNews(
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
            pagination: pagination, search: search, params: _newsFilter?.params)
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
  // MARK: - FUNCTIONS

  void resetFilter() {
    // _newsFilter = null;
  }

  // MARK: -
  // MARK: - PUSH

  void showNewsFilterSheet(BuildContext context, Function() onFilter) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => NewsFilterPageViewScreenWidget(
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
                }));
  }

  void showNewsCreationScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewsCreateScreenWidget(
                onPop: (news) => {
                      _news.insert(0, news),
                      notifyListeners(),
                      Toast().showTopToast(context, Titles.newsWasAdded)
                    })));
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
            builder: (context) => NewsCommentsScreenWidget(
                tag: index.toString(), news: _news[index])));
  }
}
