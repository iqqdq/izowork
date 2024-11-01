// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/features/objects/view/objects_filter_sheet/objects_filter_page_view_screen_body.dart';

class ObjectsFilterViewModel with ChangeNotifier {
  final ObjectsFilter? objectsFilter;

  final List<ObjectStage> objectStages;

  final List<String> _options = [];
  List<String> get options => _options;

  List<int> tags = [];

  final List<String> options2 = ['По возрастанию', 'По убыванию'];
  List<int> tags2 = [];

  User? _manager;
  User? get manager => _manager;

  Company? _designer;
  Company? get designer => _designer;

  Company? _contractor;
  Company? get contractor => _contractor;

  Company? _customer;
  Company? get customer => _customer;

  ObjectsFilterViewModel(
    this.objectStages,
    this.objectsFilter,
  ) {
    objectStages.forEach((element) {
      _options.add(element.name);
    });

    if (objectsFilter != null) {
      _manager = objectsFilter?.manager;
      _designer = objectsFilter?.designer;
      _contractor = objectsFilter?.contractor;
      _customer = objectsFilter?.customer;
      tags = objectsFilter!.tags;
      tags2 = objectsFilter!.tags2;
    }

    notifyListeners();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future setManager(User? user) async {
    _manager = user;
    notifyListeners();
  }

  Future setCompany(Company? company, int index) async {
    switch (index) {
      case 0:
        _designer = company;
        break;
      case 1:
        _contractor = company;
        break;
      case 2:
        _customer = company;
        break;
      default:
    }

    notifyListeners();
  }

  void sortByStage(int index) {
    tags.contains(index)
        ? tags.removeWhere((element) => element == index)
        : tags.add(index);
    notifyListeners();
  }

  void sortByEffectiveness(int index) {
    if (tags2.contains(index)) {
      tags2.clear();
    } else {
      tags2.clear();
      tags2.add(index);
    }

    notifyListeners();
  }

  Future apply(Function(List<String>) didReturnParams) async {
    String sortBy = '&sort_by=';
    String sortOrder = '&sort_order=';
    List<String> params = [];

    if (_manager != null) {
      params.add('&manager_id=${_manager!.id}');
    }

    if (_designer != null) {
      params.add('&designer_id=${_designer!.id}');
    }

    if (_contractor != null) {
      params.add('&contractor_id=${_contractor!.id}');
    }

    if (_customer != null) {
      params.add('&customer_id=${_customer!.id}');
    }

    if (tags.isNotEmpty) {
      var state = '&object_stage_id=';

      tags.forEach((tag) {
        objectStages.forEach((objectStage) {
          if (options[tag] == objectStage.name) {
            state += '${objectStage.id},';
          }
        });
      });

      state = state.characters.last == ','
          ? state.substring(0, state.length - 1)
          : state;

      params.add(state);
    }

    if (tags2.isNotEmpty) {
      sortBy = sortBy + 'efficiency';

      if (tags2.first == 0) {
        sortOrder = sortOrder.contains('asc') || sortOrder.contains('desc')
            ? sortOrder + ',asc'
            : sortOrder = sortOrder + 'asc';
      } else {
        sortOrder = sortOrder.contains('asc') || sortOrder.contains('desc')
            ? sortOrder + ',desc'
            : sortOrder = sortOrder + 'desc';
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
    _manager = null;
    _designer = null;
    _contractor = null;
    _customer = null;
    tags.clear();
    tags2.clear();
    notifyListeners();
    onResetTap();
  }
}
