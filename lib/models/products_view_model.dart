// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/product.dart';
import 'package:izowork/repositories/product_repository.dart';
import 'package:izowork/screens/product/product_screen.dart';
import 'package:izowork/screens/products/products_filter_sheet/products_filter_page_view_screen.dart';
import 'package:izowork/screens/products/products_filter_sheet/products_filter_page_view_screen_body.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ProductsViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<Product> _products = [];
  Product? _product;
  ProductsFilter? _productsFilter;

  List<Product> get products {
    return _products;
  }

  Product? get product {
    return _product;
  }

  ProductsFilter? get productsFilter {
    return _productsFilter;
  }

  ProductsViewModel() {
    getProductList(pagination: Pagination(offset: 0, size: 50), search: '');
  }

  // MARK: -
  // MARK: - API CALL

  Future getProductById(BuildContext context, String id) async {
    loadingStatus = LoadingStatus.searching;

    await ProductRepository().getProduct(id).then((response) => {
          if (response is Product)
            {
              _product = response,
              loadingStatus = LoadingStatus.completed,
            }
          else if (response is ErrorResponse)
            {
              loadingStatus = LoadingStatus.error,
              Toast().showTopToast(context, response.message ?? 'Ошибка')
            },
          notifyListeners()
        });
  }

  Future getProductList(
      {required Pagination pagination, required String search}) async {
    if (pagination.offset == 0) {
      loadingStatus = LoadingStatus.searching;
      _products.clear();

      Future.delayed(Duration.zero, () async {
        notifyListeners();
      });
    }
    await ProductRepository()
        .getProducts(
            pagination: pagination,
            search: search,
            params: _productsFilter?.params)
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
              notifyListeners()
            });
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void resetFilter() {
    _productsFilter = null;
  }

  // MARK: -
  // MARK: - PUSH

  void showProductPageViewScreen(BuildContext context, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ProductPageScreenWidget(product: _products[index])));
  }

  void showProductFilterSheet(BuildContext context, Function() onFilter) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => ProductsFilterPageViewScreenWidget(
            productsFilter: _productsFilter,
            onPop: (productsFilter) => {
                  if (productsFilter == null)
                    {
                      // CLEAR
                      resetFilter(),
                      onFilter()
                    }
                  else
                    {
                      // FILTER
                      _productsFilter = productsFilter,
                      onFilter()
                    }
                }));
  }
}
