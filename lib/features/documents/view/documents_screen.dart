import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/features/documents/view_model/documents_view_model.dart';

import 'package:izowork/features/documents/view/documents_screen_body.dart';
import 'package:izowork/models/models.dart';
import 'package:provider/provider.dart';

class DocumentsScreenWidget extends StatelessWidget {
  final String? objectId;
  final String? officeId;
  final Document? document;

  const DocumentsScreenWidget({
    Key? key,
    this.objectId,
    this.officeId,
    this.document,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DocumentsViewModel(
              objectId,
              officeId,
              document,
            ),
        child: DocumentsScreenBodyWidget(
            title: document?.name ?? Titles.documents));
  }
}
