// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/screens/deals/deals_filter_sheet/deals_filter_page_view_screen_body.dart';

class DealsFilterViewModel with ChangeNotifier {
  final DealsFilter? dealsFilter;

  final List<String> _options = ['Закрытые', 'В работе'];
  List<int> tags = [];

  User? _responsible;
  MapObject? _object;
  Company? _company;

  User? get responsible => _responsible;

  MapObject? get object => _object;

  Company? get company => _company;

  List<String> get options => _options;

  DealsFilterViewModel(this.dealsFilter) {
    if (dealsFilter != null) {
      _responsible = dealsFilter!.responsible;
      _object = dealsFilter!.object;
      _company = dealsFilter!.company;

      if (dealsFilter!.tags.isNotEmpty) {
        sortByStage(dealsFilter!.tags.first);
      }
    }
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future setUser(User? user) async {
    _responsible = user;
    notifyListeners();
  }

  Future setObject(MapObject? object) async {
    _object = object;
    notifyListeners();
  }

  Future setCompany(Company? company) async {
    _company = company;
    notifyListeners();
  }

  void sortByStage(int index) {
    if (tags.contains(index)) {
      tags.clear();
    } else {
      tags.clear();
      tags.add(index);
    }

    notifyListeners();
  }

  Future apply(Function(List<String>) didReturnParams) async {
    String sortBy = '&sort_by=';
    String sortOrder = '&sort_order=';
    List<String> params = [];

    if (_responsible != null) {
      params.add('&responsible_id=${_responsible!.id}');
    }

    if (_object != null) {
      params.add('&object_id=${_object!.id}');
    }

    if (_company != null) {
      params.add('&company_id=${_company!.id}');
    }

    if (tags.isNotEmpty) {
      var state = '&closed=';

      state += tags.first == 0 ? '1' : '0';

      params.add(state);
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
    _object = null;
    _company = null;
    tags.clear();
    notifyListeners();
    onResetTap();
  }
}
