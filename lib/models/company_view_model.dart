// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/helpers/helpers.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/screens/company_create/company_create_screen.dart';
import 'package:izowork/screens/contact/contact_screen.dart';
import 'package:izowork/screens/product/product_screen.dart';
import 'package:izowork/screens/products/products_filter_sheet/products_filter_page_view_screen_body.dart';
import 'package:izowork/screens/profile/profile_screen.dart';
import 'package:izowork/screens/single_company_map/single_company_map_screen.dart';
import 'package:izowork/services/local_storage/local_storage.dart';

class CompanyViewModel with ChangeNotifier {
  final Company selectedCompany;

  LoadingStatus loadingStatus = LoadingStatus.empty;

  Company? _company;

  final List<Product> _products = [];

  ProductsFilter? _productsFilter;

  Company? get company => _company;

  // List<Product> get products => _products;

  ProductsFilter? get productsFilter => _productsFilter;

  CompanyViewModel(this.selectedCompany) {
    _company = selectedCompany;
    getCompanyById(null, selectedCompany.id);
    // .then((value) => getProductList(
    //       pagination: Pagination(offset: 0, size: 50),
    //       search: '',));
  }

  // MARK: -
  // MARK: - API CALL

  Future getCompanyById(BuildContext? context, String id) async {
    loadingStatus = LoadingStatus.searching;

    await CompanyRepository()
        .getCompany(id)
        .then((response) => {
              if (response is Company)
                {
                  _company = response,
                  loadingStatus = LoadingStatus.completed,
                }
              else if (response is ErrorResponse)
                {
                  if (context != null)
                    Toast().showTopToast(context, response.message ?? 'Ошибка'),
                  loadingStatus = LoadingStatus.error,
                }
            })
        .whenComplete(() => notifyListeners());
  }

  // TODO: DELETE
  // Future getProductList({
  //   required Pagination pagination,
  //   required String search,
  // }) async {
  //   if (pagination.offset == 0) {
  //     _products.clear();
  //   }

  //   await ProductRepository()
  //       .getProducts(
  //         pagination: pagination,
  //         search: search,
  //         companyId: _company?.id ?? selectedCompany.id,
  //         params: _productsFilter?.params,
  //       )
  //       .then((response) => {
  //             if (response is List<Product>)
  //               {
  //                 if (_products.isEmpty)
  //                   {
  //                     response.forEach((user) {
  //                       _products.add(user);
  //                     })
  //                   }
  //                 else
  //                   {
  //                     response.forEach((newUser) {
  //                       bool found = false;

  //                       _products.forEach((user) {
  //                         if (newUser.id == user.id) {
  //                           found = true;
  //                         }
  //                       });

  //                       if (!found) {
  //                         _products.add(newUser);
  //                       }
  //                     })
  //                   },
  //                 loadingStatus = LoadingStatus.completed
  //               }
  //             else
  //               loadingStatus = LoadingStatus.error,
  //             notifyListeners()
  //           });
  // }

  // MARK: -
  // MARK: - FUNCTIONS

  void resetFilter() {
    _productsFilter = null;
  }

  void openUrl(String url) async {
    if (url.isNotEmpty) {
      WebViewHelper webViewHelper = WebViewHelper();
      String? nativeUrl;

      if (url.contains('t.me')) {
        nativeUrl = 'tg:resolve?domain=${url.replaceAll('t.me/', '')}';
      } else if (url.characters.first == '@') {
        nativeUrl = 'instagram://user?username=${url.replaceAll('@', '')}';
      }

      if (Platform.isAndroid) {
        if (nativeUrl != null) {
          AndroidIntent intent = AndroidIntent(
              action: 'android.intent.action.VIEW', data: nativeUrl);

          if ((await intent.canResolveActivity()) == true) {
            await intent.launch();
          }
        } else {
          webViewHelper.openWebView(url);
        }
      } else {
        nativeUrl != null
            ? webViewHelper.openWebView(nativeUrl)
            : webViewHelper.openWebView(url);
      }
    }
  }

  // MARK: -
  // MARK: - PUSH

  Future showUserScreen(BuildContext context) async {
    if (_company?.manager == null) return;

    User? user = await GetIt.I<LocalStorageService>().getUser();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileScreenWidget(
                isMine: _company?.manager?.id == user?.id,
                user: _company!.manager!,
                onPop: (user) => {
                      if (context.mounted)
                        {
                          _company?.manager = user,
                          notifyListeners(),
                        }
                    })));
  }

  void showProductPageScreen(BuildContext context, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ProductPageScreenWidget(product: _products[index])));
  }

  void showSingleCompanyOnMap(BuildContext context) {
    if (_company != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SingleCompanyMapScreenWidget(company: _company!)));
    }
  }

  void showCompanyEditScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CompanyCreateScreenWidget(
                company: company,
                onPop: (company) => {
                      getCompanyById(
                        context,
                        selectedCompany.id,
                      )
                    })));
  }

  // TODO: - DELETE
  // void showProductFilterSheet(BuildContext context, Function() onFilter) {
  //   showCupertinoModalBottomSheet(
  //       enableDrag: false,
  //       topRadius: const Radius.circular(16.0),
  //       barrierColor: Colors.black.withOpacity(0.6),
  //       backgroundColor: HexColors.white,
  //       context: context,
  //       builder: (sheetContext) => ProductsFilterPageViewScreenWidget(
  //           productsFilter: _productsFilter,
  //           onPop: (productsFilter) => {
  //                 if (productsFilter == null)
  //                   {
  //                     // CLEAR
  //                     resetFilter(),
  //                     onFilter()
  //                   }
  //                 else
  //                   {
  //                     // FILTER
  //                     _productsFilter = productsFilter,
  //                     onFilter()
  //                   }
  //               }));
  // }

  void showContactScreen(
    BuildContext context,
    int index,
  ) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactScreenWidget(
                contact: _company!.contacts[index],
                onDelete: (contact) => {
                      if (_company == null)
                        {
                          _company?.contacts.removeWhere(
                            (element) => element.id == contact.id,
                          ),
                        },
                      selectedCompany.contacts.removeWhere(
                        (element) => element.id == contact.id,
                      ),
                      notifyListeners()
                    })));
  }
}
