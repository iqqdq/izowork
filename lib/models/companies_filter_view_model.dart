// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/entities/response/user.dart';
import 'package:izowork/screens/companies/companies_filter_sheet/companies_filter_page_view_screen_body.dart';

class CompaniesFilterViewModel with ChangeNotifier {
  final CompaniesFilter? companiesFilter;

  List<String> options = ['А-Я', 'Я-А'];
  List<int> tags = [];

  List<String> options2 = ['Поставщик', 'Покупатель', 'Проектировщик'];
  List<int> tags2 = [];

  User? _user;

  User? get user {
    return _user;
  }

  CompaniesFilterViewModel(this.companiesFilter) {
    if (companiesFilter != null) {
      _user = companiesFilter?.user;
      tags = companiesFilter!.tags;
      tags2 = companiesFilter!.tags2;
      notifyListeners();
    }
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future setUser(User? user) async {
    _user = user;
    notifyListeners();
  }

  void sortByAlphabet(int index) {
    if (tags.contains(index)) {
      tags.clear();
    } else {
      tags.clear();
      tags.add(index);
    }

    notifyListeners();
  }

  void sortByType(int index) {
    tags2.contains(index)
        ? tags2.removeWhere((element) => element == index)
        : tags2.add(index);
    notifyListeners();
  }

  Future apply(Function(List<String>) didReturnParams) async {
    String sortBy = '&sort_by=';
    String sortOrder = '&sort_order=';
    List<String> params = [];

    if (_user != null) {
      params.add('&manager_id=${_user!.id}');
    }

    if (tags.isNotEmpty) {
      sortBy = sortBy + 'name';

      if (tags.first == 0) {
        sortOrder = sortOrder.contains('asc') || sortOrder.contains('desc')
            ? sortOrder + ',asc'
            : sortOrder = sortOrder + 'asc';
      } else {
        sortOrder = sortOrder.contains('asc') || sortOrder.contains('desc')
            ? sortOrder + ',desc'
            : sortOrder = sortOrder + 'desc';
      }
    }

    if (tags2.isNotEmpty) {
      tags2.forEach((element) {
        params.add('&type=${options2[element]}');
      });
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
    _user = null;
    tags.clear();
    tags2.clear();
    notifyListeners();
    onResetTap();
  }
}
