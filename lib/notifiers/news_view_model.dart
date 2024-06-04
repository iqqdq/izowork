// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/screens/news/news_filter_sheet/news_filter_page_view_screen_body.dart';

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
      _news.clear();
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

  void setFilter(NewsFilter newsFilter) {
    _newsFilter = newsFilter;
    notifyListeners();
  }

  void resetFilter() => _newsFilter = null;
}
