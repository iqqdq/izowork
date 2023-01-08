import 'package:flutter/material.dart';
import 'package:izowork/models/documents_view_model.dart';
import 'package:izowork/screens/documents/documents_screen_body.dart';
import 'package:provider/provider.dart';

class DocumentsScreenWidget extends StatelessWidget {
  const DocumentsScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DocumentsViewModel(),
        child: const DocumentsScreenBodyWidget());
  }
}
