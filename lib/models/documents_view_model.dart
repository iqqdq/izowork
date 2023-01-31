import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/entities/object.dart';
import 'package:izowork/screens/documents/documents_filter_sheet/documents_filter_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DocumentsViewModel with ChangeNotifier {
  final Object? object;

  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  DocumentsViewModel(this.object);

  // MARK: -
  // MARK: - FUNCTIONS

  // MARK: -
  // MARK: - PUSH

  void showFilesFilterSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) =>
            DocumentsFilterWidget(onApplyTap: () => {}, onResetTap: () => {}));
  }
}
