// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/helpers/helpers.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/screens/contacts/contacts_filter_sheet/contacts_filter_page_view_screen_body.dart';

class ContactsViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<Contact> _contacts = [];

  ContactsFilter? _contactsFilter;

  ContactsFilter? get contactsFilter => _contactsFilter;

  List<Contact> get contacts => _contacts;

  ContactsViewModel() {
    getContactList(pagination: Pagination(offset: 0, size: 50));
  }

  // MARK: -
  // MARK: - API CALL

  Future getContactList({
    required Pagination pagination,
    String? search,
  }) async {
    if (pagination.offset == 0) {
      _contacts.clear();
    }

    await ContactRepository()
        .getContacts(
          pagination: pagination,
          search: search,
          params: _contactsFilter?.params,
        )
        .then((response) => {
              if (response is List<Contact>)
                {
                  if (_contacts.isEmpty)
                    {
                      response.forEach((contact) {
                        _contacts.add(contact);
                      })
                    }
                  else
                    {
                      response.forEach((newContact) {
                        bool found = false;

                        _contacts.forEach((contact) {
                          if (newContact.id == contact.id) {
                            found = true;
                          }
                        });

                        if (!found) {
                          _contacts.add(newContact);
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

  void setContact(Contact contact) {
    _contacts.insert(0, contact);
    notifyListeners();
  }

  void removeContact(Contact contact) {
    _contacts.removeWhere((element) => element.id == contact.id);
    notifyListeners();
  }

  void setFilter(ContactsFilter contactsFilter) {
    _contactsFilter = contactsFilter;
    notifyListeners();
  }

  void resetFilter() {
    _contactsFilter = null;
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
