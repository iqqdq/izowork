import 'package:flutter/material.dart';
import 'package:izowork/entities/response/contact.dart';
import 'package:izowork/models/contact_view_model.dart';
import 'package:izowork/screens/contact/contact_screen_body.dart';
import 'package:provider/provider.dart';

class ContactScreenWidget extends StatelessWidget {
  final Contact contact;

  const ContactScreenWidget({Key? key, required this.contact})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ContactViewModel(contact),
        child: const ContactScreenBodyWidget());
  }
}
