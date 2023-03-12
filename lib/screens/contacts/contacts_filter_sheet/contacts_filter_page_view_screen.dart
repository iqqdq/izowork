import 'package:flutter/material.dart';
import 'package:izowork/models/contacts_filter_view_model.dart';
import 'package:izowork/screens/contacts/contacts_filter_sheet/contacts_filter_page_view_screen_body.dart';
import 'package:provider/provider.dart';

class ContactsFilterPageViewScreenWidget extends StatelessWidget {
  final ContactsFilter? contactsFilter;
  final Function(ContactsFilter?) onPop;

  const ContactsFilterPageViewScreenWidget(
      {Key? key, this.contactsFilter, required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ContactsFilterViewModel(contactsFilter),
        child: ContactsFilterPageViewScreenBodyWidget(onPop: onPop));
  }
}
