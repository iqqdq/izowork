import 'package:flutter/material.dart';
import 'package:izowork/entities/response/contact.dart';
import 'package:izowork/models/contact_edit_view_model.dart';
import 'package:izowork/screens/contact_edit/contact_edit_screen_body.dart';
import 'package:provider/provider.dart';

class ContactEditScreenWidget extends StatelessWidget {
  final Contact? contact;
  final Function(Contact?) onPop;

  const ContactEditScreenWidget(
      {Key? key, required this.contact, required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ContactEditViewModel(contact),
        child: ContactEditScreenBodyWidget(onPop: onPop));
  }
}
