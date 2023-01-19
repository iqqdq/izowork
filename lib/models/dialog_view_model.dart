import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/screens/dialog/views/dialog_add_task_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DialogViewModel with ChangeNotifier {
  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  // MARK: -
  // MARK: - FUNCTIONS

  // MARK: -
  // MARK: - PUSH

  void showAddMapObjectSheet(BuildContext context, bool isMine, bool isFile,
      bool isAudio, bool isGroupLastMessage, String text, DateTime dateTime) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => DialogAddTaskWidget(
            isMine: isMine,
            isFile: isFile,
            isAudio: isAudio,
            isGroupLastMessage: isGroupLastMessage,
            dateTime: dateTime,
            text: text,
            onTap: () => {
                  // TODO ADD MAP OBJECT
                  Navigator.pop(context)
                }));
  }
}
