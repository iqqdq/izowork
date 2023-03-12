// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/response/contact.dart';
import 'package:izowork/repositories/contacts_repository.dart';
import 'package:izowork/screens/contact/contact_screen.dart';
import 'package:izowork/screens/contact_edit/contact_edit_screen.dart';
import 'package:izowork/screens/contacts/contacts_filter_sheet/contacts_filter_page_view_screen.dart';
import 'package:izowork/screens/contacts/contacts_filter_sheet/contacts_filter_page_view_screen_body.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<Contact> _contacts = [];

  ContactsFilter? _contactsFilter;

  ContactsFilter? get contactsFilter {
    return _contactsFilter;
  }

  List<Contact> get contacts {
    return _contacts;
  }

  ContactsViewModel() {
    getContactList(pagination: Pagination(offset: 0, size: 50));
  }

  // MARK: -
  // MARK: - API CALL

  Future getContactList(
      {required Pagination pagination, String? search}) async {
    if (pagination.offset == 0) {
      loadingStatus = LoadingStatus.searching;
      _contacts.clear();

      Future.delayed(Duration.zero, () async {
        notifyListeners();
      });
    }

    await ContactRepository()
        .getContacts(pagination: pagination, search: search)
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
            builder: (context) =>
                ContactScreenWidget(contact: _contacts[index])));
  }

  void showContactEditScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactEditScreenWidget(
                contact: null,
                onPop: (contact) => {
                      if (contact != null)
                        {_contacts.insert(0, contact), notifyListeners()}
                    })));
  }

  void showContactsFilterSheet(BuildContext context, Function() onFilter) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => ContactsFilterPageViewScreenWidget(
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
          openBrowser(url);
        }
      } else {
        if (nativeUrl != null) {
          openBrowser(nativeUrl);
        } else {
          openBrowser(url);
        }
      }
    }
  }

  void openBrowser(String url) async {
    if (await canLaunchUrl(Uri.parse(url.replaceAll(' ', '')))) {
      launchUrl(Uri.parse(url.replaceAll(' ', '')));
    } else if (await canLaunchUrl(
        Uri.parse('https://' + url.replaceAll(' ', '')))) {
      launchUrl(Uri.parse('https://' + url.replaceAll(' ', '')));
    }
  }
}
