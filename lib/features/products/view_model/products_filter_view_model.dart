import 'package:flutter/material.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/features/products/view/products_filter_sheet/products_filter_page_view_screen_body.dart';

class ProductsFilterViewModel with ChangeNotifier {
  final ProductsFilter? productsFilter;

  List<String> options = ['А-Я', 'Я-А'];
  List<int> tags = [];

  List<String> options2 = ['Сначала дорогие', 'Сначала дешевые'];
  List<int> tags2 = [];

  ProductType? _productType;

  ProductType? get productType => _productType;

  ProductsFilterViewModel(this.productsFilter) {
    if (productsFilter != null) {
      _productType = productsFilter?.productType;
      tags = productsFilter!.tags;
      tags2 = productsFilter!.tags2;
      notifyListeners();
    }
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future setProductType(ProductType? productType) async {
    _productType = productType;
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

  void sortByCost(int index) {
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

    if (_productType != null) {
      params.add('&product_type_id=${_productType!.id}');
    }

    if (tags.isNotEmpty) {
      sortBy = sortBy.contains('price') ? sortBy + ',name' : sortBy + 'name';

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
      sortBy = sortBy.contains('name') ? sortBy + ',price' : sortBy + 'price';

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
    _productType = null;
    tags.clear();
    tags2.clear();
    notifyListeners();
    onResetTap();
  }
}
