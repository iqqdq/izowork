// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/repositories/repositories.dart';

class ProductTypeSelectionViewModel with ChangeNotifier {
  final ProductType? selectedProductType;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<ProductType> _productTypes = [];

  ProductType? _productType;

  List<ProductType> get productTypes => _productTypes;

  ProductType? get productType => _productType;

  ProductTypeSelectionViewModel(this.selectedProductType) {
    _productType = selectedProductType;
    notifyListeners();

    getProductTypeList();
  }

  // MARK: -
  // MARK: - API CALL

  Future getProductTypeList() async {
    await sl<ProductRepositoryInterface>()
        .getProductTypes()
        .then((response) => {
              if (response is List<ProductType>)
                {
                  response.forEach((productType) {
                    _productTypes.add(productType);
                  }),
                  loadingStatus = LoadingStatus.completed,
                }
              else
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => notifyListeners());
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void select(int index) {
    _productType = productTypes[index];
    notifyListeners();
  }
}
