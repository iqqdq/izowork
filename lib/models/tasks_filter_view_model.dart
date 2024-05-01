// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/entities/response/user.dart';
import 'package:izowork/screens/tasks/tasks_filter_sheet/tasks_filter_page_view_screen_body.dart';

class TasksFilterViewModel with ChangeNotifier {
  List<String> stages;
  final TasksFilter? tasksFilter;

  List<int> tags = [];
  List<String> _options = [];

  User? _user;

  User? get user => _user;

  List<String> get options => _options;

  TasksFilterViewModel(this.stages, this.tasksFilter) {
    _options = stages;

    if (tasksFilter != null) {
      _user = tasksFilter?.user;
      tags = tasksFilter!.tags;
    }

    notifyListeners();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future setUser(User? user) async {
    _user = user;
    notifyListeners();
  }

  void sortByStage(int index) {
    tags.contains(index)
        ? tags.removeWhere((element) => element == index)
        : tags.add(index);
    notifyListeners();
  }

  Future apply(Function(List<String>) didReturnParams) async {
    List<String> params = [];

    if (_user != null) {
      params.add('&responsible_id=${_user!.id}');
    }

    if (tags.isNotEmpty) {
      var state = '&state=';

      tags.forEach((element) {
        state += '${_options[element]},';
      });

      state = state.characters.last == ','
          ? state.substring(0, state.length - 1)
          : state;

      params.add(state);
    }

    didReturnParams(params);
  }

  void reset(VoidCallback onResetTap) {
    _user = null;
    tags.clear();
    notifyListeners();
    onResetTap();
  }
}
