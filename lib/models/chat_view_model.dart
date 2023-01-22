import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/screens/chat/chat_filter_sheet/chat_filter_page_view_widget.dart';
import 'package:izowork/screens/dialog/dialog_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ChatViewModel with ChangeNotifier {
  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  // MARK: -
  // MARK: - FUNCTIONS

  // MARK: -
  // MARK: - PUSH

  void showDialogScreen(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const DialogScreenWidget()));
  }

  void showMapFilterSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => ChatFilterPageViewWidget(
            onApplyTap: () => {Navigator.pop(context)},
            onResetTap: () => {Navigator.pop(context)}));
  }
}
