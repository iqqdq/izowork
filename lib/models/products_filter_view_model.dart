import 'package:flutter/material.dart';
import 'package:izowork/entities/response/product_type.dart';
import 'package:izowork/screens/products/products_filter_sheet/products_filter_page_view_screen_body.dart';

class ProductsFilterViewModel with ChangeNotifier {
  final ProductsFilter? productsFilter;

  List<String> options = ['А-Я', 'Я-А'];
  List<int> tags = [];

  List<String> options2 = ['Сначала дорогие', 'Сначала дешевые'];
  List<int> tags2 = [];

  ProductType? _productType;

  ProductType? get productType {
    return _productType;
  }

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
    List<String> params = [];

    if (_productType != null) {
      params.add('&product_type_id=${_productType!.id}');
    }

    if (tags.isNotEmpty) {
      params.add('&sort_by=name');
    }

    if (tags2.isNotEmpty) {
      params.add('&sort_by=price');
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
