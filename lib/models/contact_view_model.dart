import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/entities/response/contact.dart';
import 'package:izowork/screens/contact_create/contact_create_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactViewModel with ChangeNotifier {
  final Contact selectedContact;
  final Function(Contact) onDelete;

  Contact? _contact;

  Contact? get contact {
    return _contact;
  }

  LoadingStatus loadingStatus = LoadingStatus.empty;

  ContactViewModel(this.selectedContact, this.onDelete) {
    _contact = selectedContact;
    notifyListeners();
  }

  // MARK: -
  // MARK: - PUSH

  void showContactEditScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactCreateScreenWidget(
                contact: selectedContact,
                onPop: (contact) => {_contact = contact, notifyListeners()},
                onDelete: (contact) => onDelete(contact))));
  }

  // MARK: -
  // MARK: - ACTIONS

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

  // MARK: -
  // MARK: - FUNCTIONS

  void openBrowser(String url) async {
    if (await canLaunchUrl(Uri.parse(url.replaceAll(' ', '')))) {
      launchUrl(Uri.parse(url.replaceAll(' ', '')));
    } else if (await canLaunchUrl(
        Uri.parse('https://' + url.replaceAll(' ', '')))) {
      launchUrl(Uri.parse('https://' + url.replaceAll(' ', '')));
    }
  }
}
