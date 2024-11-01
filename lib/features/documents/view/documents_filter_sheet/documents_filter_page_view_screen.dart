import 'package:flutter/material.dart';
import 'package:izowork/features/documents/view_model/documents_filter_view_model.dart';

import 'package:izowork/features/documents/view/documents_filter_sheet/documents_filter_page_view_screen_body.dart';
import 'package:provider/provider.dart';

class DocumentsFilterPageViewScreenWidget extends StatelessWidget {
  final DocumentsFilter? documentsFilter;
  final Function(DocumentsFilter?) onPop;

  const DocumentsFilterPageViewScreenWidget({
    Key? key,
    this.documentsFilter,
    required this.onPop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DocumentsFilterViewModel(documentsFilter),
      child: DocumentsFilterPageViewScreenBodyWidget(onPop: onPop),
    );
  }
}
