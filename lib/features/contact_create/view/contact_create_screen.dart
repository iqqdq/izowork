import 'package:flutter/material.dart';
import 'package:izowork/features/contact_create/view_model/contact_create_view_model.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/features/contact_create/view/contact_create_screen_body.dart';
import 'package:provider/provider.dart';

class ContactCreateScreenWidget extends StatelessWidget {
  final Company? company;
  final Contact? contact;
  final Function(Contact?) onPop;
  final Function(Contact)? onDelete;

  const ContactCreateScreenWidget(
      {Key? key,
      required this.company,
      required this.contact,
      required this.onPop,
      required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ContactCreateViewModel(
        company,
        contact,
        onDelete,
      ),
      child: ContactCreateScreenBodyWidget(onPop: onPop),
    );
  }
}
