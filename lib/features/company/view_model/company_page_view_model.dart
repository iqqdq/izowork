// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/helpers/helpers.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/repositories/repositories.dart';

class CompanyPageViewModel with ChangeNotifier {
  final String id;

  LoadingStatus loadingStatus = LoadingStatus.empty;

  Company? _company;

  Company? get company => _company;

  CompanyPageViewModel(this.id) {
    getCompanyById(id);
  }

  // MARK: -
  // MARK: - API CALL

  Future getCompanyById(String id) async {
    loadingStatus = LoadingStatus.searching;

    await sl<CompanyRepositoryInterface>()
        .getCompany(id)
        .then((response) => {
              if (response is Company)
                {
                  _company = response,
                  loadingStatus = LoadingStatus.completed,
                }
              else if (response is ErrorResponse)
                {
                  Toast().showTopToast(response.message ?? 'Произошла ошибка'),
                  loadingStatus = LoadingStatus.error,
                }
            })
        .whenComplete(() => notifyListeners());
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void setManager(User? user) {
    if (user == null) return;

    _company?.manager = user;
    notifyListeners();
  }

  void setContact(Contact contact) {
    _company?.contacts.insert(0, contact);

    notifyListeners();
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
