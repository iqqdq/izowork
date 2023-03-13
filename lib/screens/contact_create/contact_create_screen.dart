import 'package:flutter/material.dart';
import 'package:izowork/entities/response/contact.dart';
import 'package:izowork/models/contact_create_view_model.dart';
import 'package:izowork/screens/contact_create/contact_create_screen_body.dart';
import 'package:provider/provider.dart';

class ContactCreateScreenWidget extends StatelessWidget {
  final Contact? contact;
  final Function(Contact?) onPop;
  final Function(Contact)? onDelete;

  const ContactCreateScreenWidget(
      {Key? key,
      required this.contact,
      required this.onPop,
      required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ContactCreateViewModel(contact, onDelete),
        child: ContactCreateScreenBodyWidget(onPop: onPop));
  }
}
