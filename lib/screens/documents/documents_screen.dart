import 'package:flutter/material.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/screens/documents/documents_screen_body.dart';
import 'package:provider/provider.dart';

class DocumentsScreenWidget extends StatelessWidget {
  final String? title;
  final String? id;
  final String? namespace;

  const DocumentsScreenWidget({Key? key, this.title, this.id, this.namespace})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DocumentsViewModel(id, namespace),
        child: DocumentsScreenBodyWidget(title: title));
  }
}
