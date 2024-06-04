import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';

import 'package:izowork/models/models.dart';
import 'package:izowork/helpers/helpers.dart';

class ContactViewModel with ChangeNotifier {
  final Contact selectedContact;

  Contact? _contact;

  Contact? get contact => _contact;

  LoadingStatus loadingStatus = LoadingStatus.empty;

  ContactViewModel(this.selectedContact) {
    _contact = selectedContact;
    notifyListeners();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void setContact(Contact? contact) {
    _contact = contact;
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
