import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/entities/response/user.dart';
import 'package:izowork/helpers/browser.dart';
import 'package:izowork/repositories/user_repository.dart';
import 'package:izowork/screens/profile_edit/profile_edit_screen.dart';

class ProfileViewModel with ChangeNotifier {
  final User currentUser;

  LoadingStatus loadingStatus = LoadingStatus.empty;
  User? _user;

  User? get user => _user;

  ProfileViewModel(this.currentUser) {
    getUserProfile(currentUser.id);
  }

  // MARK: -
  // MARK: - API CALL

  Future getUserProfile(String? id) async {
    loadingStatus = LoadingStatus.searching;

    await UserRepository()
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

  // MARK: -
  // MARK: - ACTIONS

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

  void showProfileEditScreen(BuildContext context) {
    if (_user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileEditScreenWidget(
              user: _user!,
              onPop: (user) => {
                    _user = user,
                    notifyListeners(),
                  }),
        ),
      );
    }
  }
}
