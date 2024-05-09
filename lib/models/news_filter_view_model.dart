import 'package:flutter/material.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/screens/news/news_filter_sheet/news_filter_page_view_screen_body.dart';

class NewsFilterViewModel with ChangeNotifier {
  final NewsFilter? newsFilter;

  List<String> options = ['Все', 'Важные'];
  List<int> tags = [];

  List<String> options2 = ['Сначала новые', 'Сначала старые'];
  List<int> tags2 = [];

  User? _responsible;

  User? get responsible => _responsible;

  NewsFilterViewModel(this.newsFilter) {
    if (newsFilter != null) {
      _responsible = newsFilter?.resposible;
      tags = newsFilter!.tags;
      tags2 = newsFilter!.tags2;
      notifyListeners();
    }
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future setUser(User? user) async {
    _responsible = user;
    notifyListeners();
  }

  void sortByStatus(int index) {
    tags.clear();
    tags.add(index);
    notifyListeners();
  }

  void sortByCreatedAt(int index) {
    tags2.clear();
    tags2.add(index);
    notifyListeners();
  }

  Future apply(Function(List<String>) didReturnParams) async {
    String sortBy = '&sort_by=';
    String sortOrder = '&sort_order=';
    List<String> params = [];

    if (_responsible != null) {
      params.add('&user_id=${_responsible!.id}');
    }

    if (tags.isNotEmpty) {
      if (tags.first == 1) {
        params.add('&important=true');
      }
    }

    if (tags2.isNotEmpty) {
      sortBy = sortBy + 'created_at';

      if (tags2.first == 0) {
        sortOrder = sortOrder.contains('asc') || sortOrder.contains('desc')
            ? sortOrder + ',desc'
            : sortOrder = sortOrder + 'desc';
      } else {
        sortOrder = sortOrder.contains('asc') || sortOrder.contains('desc')
            ? sortOrder + ',asc'
            : sortOrder = sortOrder + 'asc';
      }
    }

    if (sortBy != '&sort_by=') {
      params.add(sortBy);
    }

    if (sortOrder != '&sort_order=') {
      params.add(sortOrder);
    }

    didReturnParams(params);
  }

  void reset(VoidCallback onResetTap) {
    _responsible = null;
    tags.clear();
    tags2.clear();
    notifyListeners();
    onResetTap();
  }
}
