import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/helpers/helpers.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/repositories/repositories.dart';

class ProfileViewModel with ChangeNotifier {
  final User currentUser;

  LoadingStatus loadingStatus = LoadingStatus.empty;

  User? _user;

  User? get user => _user;

  num? _rating;

  num? get rating => _rating;

  ProfileViewModel(this.currentUser) {
    getUserProfile(currentUser.id)
        .whenComplete(() => getUserRating(currentUser.id));
  }

  // MARK: -
  // MARK: - API CALL

  Future getUserProfile(String id) async {
    loadingStatus = LoadingStatus.searching;

    await sl<UserRepositoryInterface>()
        .getUser(id)
        .then((response) => {
              if (response is User)
                {
                  _user = response,
                  loadingStatus = LoadingStatus.completed,
                }
              else
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => notifyListeners());
  }

  Future getUserRating(String id) async {
    loadingStatus = LoadingStatus.searching;

    await sl<UserRepositoryInterface>()
        .getUserRating(id)
        .then((response) => {
              if (response is num)
                {
                  _rating = response,
                  loadingStatus = LoadingStatus.completed,
                }
              else
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => notifyListeners());
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void setUser(User user) {
    _user = user;
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
