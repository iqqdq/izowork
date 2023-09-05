import 'package:flutter/material.dart';
import 'package:izowork/entities/response/company.dart';
import 'package:izowork/entities/response/contact.dart';
import 'package:izowork/models/contacts_view_model.dart';
import 'package:izowork/screens/contacts/contacts_screen_body.dart';
import 'package:provider/provider.dart';

class ContactsScreenWidget extends StatelessWidget {
  final Company? company;
  final Function(Contact)? onPop;

  const ContactsScreenWidget({Key? key, this.company, this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ContactsViewModel(),
        child: ContactsScreenBodyWidget(company: company, onPop: onPop));
  }
}
