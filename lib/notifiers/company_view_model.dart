// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/helpers/helpers.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/screens/products/products_filter_sheet/products_filter_page_view_screen_body.dart';

class CompanyViewModel with ChangeNotifier {
  final Company selectedCompany;

  LoadingStatus loadingStatus = LoadingStatus.empty;

  Company? _company;

  Company? get company => _company;

  final List<Product> _products = [];

  List<Product> get products => _products;

  ProductsFilter? _productsFilter;

  ProductsFilter? get productsFilter => _productsFilter;

  CompanyViewModel(this.selectedCompany) {
    _company = selectedCompany;
    getCompanyById(selectedCompany.id);
  }

  // MARK: -
  // MARK: - API CALL

  Future getCompanyById(String id) async {
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
                  Toast().showTopToast(response.message ?? 'Ошибка'),
                  loadingStatus = LoadingStatus.error,
                }
            })
        .whenComplete(() => notifyListeners());
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void setManager(User? user) {
    _company?.manager = user;
    notifyListeners();
  }

  void setContact(Contact contact) {
    if (_company != null) {
      _company?.contacts.removeWhere(
        (element) => element.id == contact.id,
      );
    }

    selectedCompany.contacts.removeWhere(
      (element) => element.id == contact.id,
    );

    notifyListeners();
  }

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
          webViewHelper.open(url);
        }
      } else {
        nativeUrl != null
            ? webViewHelper.open(nativeUrl)
            : webViewHelper.open(url);
      }
    }
  }
}
