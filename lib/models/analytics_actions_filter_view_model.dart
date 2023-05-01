// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/entities/response/office.dart';
import 'package:izowork/entities/response/user.dart';
import 'package:izowork/screens/analytics/analytics_actions/analytics_actions_filter_sheet/analytics_actions_filter_page_view_screen_body.dart';

class AnalyticsActionsFilterViewModel with ChangeNotifier {
  final AnalyticsActionsFilter? analyticsActionsFilter;

  final DateTime minDateTime = DateTime(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .year -
          5,
      1,
      1);

  final DateTime maxDateTime = DateTime(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .year +
          5,
      1,
      1);

  Office? _office;

  User? _user;

  DateTime? _fromDateTime;

  DateTime? _toDateTime;

  Office? get office {
    return _office;
  }

  User? get user {
    return _user;
  }

  DateTime? get fromDateTime {
    return _fromDateTime;
  }

  DateTime? get toDateTime {
    return _toDateTime;
  }

  AnalyticsActionsFilterViewModel(this.analyticsActionsFilter) {
    if (analyticsActionsFilter != null) {
      _office = analyticsActionsFilter?.office;
      _user = analyticsActionsFilter?.user;
      _fromDateTime = analyticsActionsFilter!.fromDateTime;
      _toDateTime = analyticsActionsFilter!.toDateTime;
    }

    notifyListeners();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future setOffice(Office? office) async {
    _office = office;
    notifyListeners();
  }

  Future setUser(User? user) async {
    _user = user;
    notifyListeners();
  }

  Future setFromDateTime(DateTime? dateTime) async {
    _fromDateTime = dateTime;
    notifyListeners();
  }

  Future setToDateTime(DateTime? dateTime) async {
    _toDateTime = dateTime;
    notifyListeners();
  }

  Future apply(Function(List<String>) didReturnParams) async {
    List<String> params = [];
    String createdAt = '&created_at=';

    if (_office != null) {
      params.add('&office_id=${_office!.id}');
    }

    if (_user != null) {
      params.add('&subject_id=${_user!.id}');
    }

    if (_fromDateTime != null) {
      if (createdAt == '&created_at=') {
        createdAt +=
            'gte:' + (_fromDateTime!.toUtc().toLocal().toIso8601String() + 'Z');
      } else {
        createdAt += ',gte:' +
            (_fromDateTime!.toUtc().toLocal().toIso8601String() + 'Z');
      }
    }

    if (_toDateTime != null) {
      if (createdAt == '&created_at=') {
        createdAt +=
            'lte:' + (_toDateTime!.toUtc().toLocal().toIso8601String() + 'Z');
      } else {
        createdAt +=
            ',lte:' + (_toDateTime!.toUtc().toLocal().toIso8601String() + 'Z');
      }
    }

    if (createdAt != '&created_at=') {
      params.add(createdAt);
    }

    didReturnParams(params);
  }

  void reset(VoidCallback onResetTap) {
    _office = null;
    _user = null;
    _fromDateTime = null;
    _toDateTime = null;
    notifyListeners();
    onResetTap();
  }
}
