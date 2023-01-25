import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';

enum SelectionType { task, deal, object }

class SelectionViewModel with ChangeNotifier {
  // INIT
  final SelectionType selectionType;

  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  int _index = 0;

  int get index {
    return _index;
  }

  SelectionViewModel(this.selectionType);

  // MARK: -
  // MARK: - FUNCTIONS

  void select(int index) {
    _index = index;
    notifyListeners();
  }
}
