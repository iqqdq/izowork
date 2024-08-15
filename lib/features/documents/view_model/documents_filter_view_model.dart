import 'package:flutter/material.dart';
import 'package:izowork/features/documents/view/documents_filter_sheet/documents_filter_page_view_screen_body.dart';

class DocumentsFilterViewModel with ChangeNotifier {
  final DocumentsFilter? documentsFilter;

  List<String> options = ['А-Я', 'Я-А'];
  List<int> tags = [];

  List<String> options2 = ['Сначала новые', 'Сначала старые'];
  List<int> tags2 = [];

  DocumentsFilterViewModel(this.documentsFilter) {
    if (documentsFilter != null) {
      tags = documentsFilter!.tags;
      tags2 = documentsFilter!.tags2;

      notifyListeners();
    }
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void sortByAlphabet(int index) {
    if (tags.contains(index)) {
      tags.clear();
    } else {
      tags.clear();
      tags.add(index);
    }

    notifyListeners();
  }

  void sortByDate(int index) {
    if (tags2.contains(index)) {
      tags2.clear();
    } else {
      tags2.clear();
      tags2.add(index);
    }

    notifyListeners();
  }

  Future apply(Function(List<String> params) didReturnParams) async {
    String sortBy = '&sort_by=';
    String sortOrder = '&sort_order=';
    List<String> params = [];

    if (tags.isNotEmpty) {
      sortBy =
          sortBy.contains('created_at') ? sortBy + ',name' : sortBy + 'name';

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
      sortBy = sortBy.contains('name')
          ? sortBy + ',created_at'
          : sortBy + 'created_at';

      if (tags2.first == 1) {
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
    tags.clear();
    tags2.clear();

    notifyListeners();

    onResetTap();
  }
}
