import 'package:flutter/material.dart';
import 'package:izowork/features/contact/view_model/contact_view_model.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/features/contact/view/contact_screen_body.dart';
import 'package:provider/provider.dart';

class ContactScreenWidget extends StatelessWidget {
  final Contact contact;
  final Function(Contact) onDelete;

  const ContactScreenWidget({
    Key? key,
    required this.contact,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ContactViewModel(contact),
      child: ContactScreenBodyWidget(onDelete: onDelete),
    );
  }
}
