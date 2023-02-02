// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/entities/response/product_type.dart';
import 'package:izowork/repositories/product_repository.dart';

class ProductTypeSelectionViewModel with ChangeNotifier {
  final ProductType? selectedProductType;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<ProductType> _productTypes = [];
  ProductType? _productType;

  List<ProductType> get productTypes {
    return _productTypes;
  }

  ProductType? get productType {
    return _productType;
  }

  ProductTypeSelectionViewModel(this.selectedProductType) {
    _productType = selectedProductType;
    notifyListeners();

    getProductTypeList();
  }

  // MARK: -
  // MARK: - API CALL

  Future getProductTypeList() async {
    await ProductRepository().getProductTypes().then((response) => {
          if (response is List<ProductType>)
            {
              if (_productTypes.isEmpty)
                {
                  response.forEach((productType) {
                    _productTypes.add(productType);
                  })
                }
              else
                {
                  response.forEach((newProductType) {
                    bool found = false;

                    _productTypes.forEach((productType) {
                      if (newProductType.id == productType.id) {
                        found = true;
                      }
                    });

                    if (!found) {
                      _productTypes.add(newProductType);
                    }
                  })
                },
              loadingStatus = LoadingStatus.completed
            }
          else
            loadingStatus = LoadingStatus.error,
          notifyListeners()
        });
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void select(int index) {
    _productType = productTypes[index];
    notifyListeners();
  }

  // MARK: -
  // MARK: - PUSH
}
