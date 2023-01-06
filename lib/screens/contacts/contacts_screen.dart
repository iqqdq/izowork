import 'package:flutter/material.dart';
import 'package:izowork/models/contacts_view_model.dart';
import 'package:izowork/screens/contacts/contacts_screen_body.dart';
import 'package:provider/provider.dart';

class ContactsScreenWidget extends StatelessWidget {
  const ContactsScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ContactsViewModel(),
        child: const ContactsScreenBodyWidget());
  }
}
