// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/screens/products/products_filter_sheet/products_filter_page_view_screen_body.dart';

class ProductsViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<Product> _products = [];

  Product? _product;

  ProductsFilter? _productsFilter;

  List<Product> get products => _products;

  Product? get product => _product;

  ProductsFilter? get productsFilter => _productsFilter;

  ProductsViewModel() {
    getProductList(pagination: Pagination(offset: 0, size: 50), search: '');
  }

  // MARK: -
  // MARK: - API CALL

  Future getProductById(String id) async {
    loadingStatus = LoadingStatus.searching;

    await ProductRepository()
        .getProduct(id)
        .then((response) => {
              if (response is Product)
                {
                  _product = response,
                  loadingStatus = LoadingStatus.completed,
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(response.message ?? 'Ошибка')
                },
            })
        .whenComplete(() => notifyListeners());
  }

  Future getProductList({
    required Pagination pagination,
    required String search,
  }) async {
    if (pagination.offset == 0) {
      _products.clear();
    }

    await ProductRepository()
        .getProducts(
          pagination: pagination,
          search: search,
          params: _productsFilter?.params,
        )
        .then((response) => {
              if (response is List<Product>)
                {
                  if (_products.isEmpty)
                    {
                      response.forEach((user) {
                        _products.add(user);
                      })
                    }
                  else
                    {
                      response.forEach((newUser) {
                        bool found = false;

                        _products.forEach((user) {
                          if (newUser.id == user.id) {
                            found = true;
                          }
                        });

                        if (!found) {
                          _products.add(newUser);
                        }
                      })
                    },
                  loadingStatus = LoadingStatus.completed
                }
              else
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => notifyListeners());
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void setFilter(ProductsFilter productsFilter) {
    _productsFilter = productsFilter;
    notifyListeners();
  }

  void resetFilter() => _productsFilter = null;
}
