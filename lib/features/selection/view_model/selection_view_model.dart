import 'package:flutter/material.dart';

class SelectionViewModel with ChangeNotifier {
  final List<String> items;
  int _index = -1;

  int get index => _index;

  SelectionViewModel(this.items);

  // MARK: -
  // MARK: - FUNCTIONS

  void select(int index) {
    _index = index;
    notifyListeners();
  }
}
