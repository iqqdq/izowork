import 'package:flutter/material.dart';

class SelectionViewModel with ChangeNotifier {
  final List<String> items;
  int _index = 0;

  int get index {
    return _index;
  }

  SelectionViewModel(this.items);

  // MARK: -
  // MARK: - FUNCTIONS

  void select(int index) {
    _index = index;
    notifyListeners();
  }
}
