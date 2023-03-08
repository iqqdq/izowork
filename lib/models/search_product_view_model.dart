// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/response/product.dart';
import 'package:izowork/repositories/product_repository.dart';

class SearchProductViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<Product> _products = [];

  List<Product> get products {
    return _products;
  }

  SearchProductViewModel() {
    getProductList(pagination: Pagination(offset: 0, size: 50));
  }

  // MARK: -
  // MARK: - API CALL

  Future getProductList(
      {required Pagination pagination, String? search}) async {
    if (pagination.offset == 0) {
      loadingStatus = LoadingStatus.searching;
      _products.clear();

      Future.delayed(Duration.zero, () async {
        notifyListeners();
      });
    }

    await ProductRepository()
        .getProducts(pagination: pagination, search: search ?? '')
        .then((response) => {
              if (response is List<Product>)
                {
                  if (_products.isEmpty)
                    {
                      response.forEach((product) {
                        _products.add(product);
                      })
                    }
                  else
                    {
                      response.forEach((newProduct) {
                        bool found = false;

                        _products.forEach((product) {
                          if (newProduct.id == product.id) {
                            found = true;
                          }
                        });

                        if (!found) {
                          _products.add(newProduct);
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
}