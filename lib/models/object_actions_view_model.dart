import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/screens/object/object_actions/object_action_create_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ObjectActionsViewModel with ChangeNotifier {
  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  final List<String> _list = [
    'Задача “Название задачи” выполнена',
    'Выполнил пункт чеклиста “Название пункта чеклиста”',
    'Добавил обьект “ЖК Жемчужина”',
    'Задача “Название задачи” выполнена',
    'Выполнил пункт чеклиста “Название пункта чеклиста”'
  ];

  List<String> get list {
    return _list;
  }

  // MARK: -
  // MARK: - PUSH

  void showActionCreateScreen(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) =>
            ObjectActionCreateSheetWidget(onTap: (action) => {}));
  }

  void showProfileScreen(BuildContext context) {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) =>
    //             ProfileScreenWidget(user: null, onPop: (user) => null)));
  }
}
