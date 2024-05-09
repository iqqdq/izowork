// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/helpers/helpers.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/screens/contact/contact_screen.dart';
import 'package:izowork/screens/contact_create/contact_create_screen.dart';
import 'package:izowork/screens/contacts/contacts_filter_sheet/contacts_filter_page_view_screen.dart';
import 'package:izowork/screens/contacts/contacts_filter_sheet/contacts_filter_page_view_screen_body.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
      loadingStatus = LoadingStatus.searching;
      _contacts.clear();

      Future.delayed(Duration.zero, () async {
        notifyListeners();
      });
    }

    await ContactRepository()
        .getContacts(
            pagination: pagination,
            search: search,
            params: _contactsFilter?.params)
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
              notifyListeners()
            });
  }

  // MARK: -
  // MARK: - PUSH

  void showContactScreen(BuildContext context, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactScreenWidget(
                contact: _contacts[index],
                onDelete: (contact) => {
                      _contacts
                          .removeWhere((element) => element.id == contact.id),
                      notifyListeners()
                    })));
  }

  void showContactEditScreen(
    BuildContext context,
    Company? company,
    Function(Contact?) onContact,
  ) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (newContext) => ContactCreateScreenWidget(
                company: company,
                contact: null,
                onDelete: null,
                onPop: (contact) => {
                      if (company == null)
                        {
                          if (contact != null)
                            {
                              _contacts.insert(0, contact),
                              if (context.mounted) notifyListeners(),
                            }
                        }
                      else
                        onContact(contact)
                    })));
  }

  void showContactsFilterSheet(BuildContext context, Function() onFilter) {
    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => ContactsFilterPageViewScreenWidget(
            contactsFilter: _contactsFilter,
            onPop: (contactsFilter) => {
                  if (contactsFilter == null)
                    {
                      // CLEAR
                      resetFilter(),
                      onFilter()
                    }
                  else
                    {
                      // FILTER
                      _contactsFilter = contactsFilter,
                      onFilter()
                    }
                }));
  }

  // MARK: -
  // MARK: - FUNCTIONS

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
          webViewHelper.openWebView(url);
        }
      } else {
        nativeUrl != null
            ? webViewHelper.openWebView(nativeUrl)
            : webViewHelper.openWebView(url);
      }
    }
  }
}
