import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/screens/actions/actions_screen.dart';
import 'package:izowork/screens/analytics/analytics_actions/analytics_actions_filter_sheet/analytics_actions_filter_page_view_widget.dart';
import 'package:izowork/screens/profile/profile_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ObjectAnalyticsActionsViewModel with ChangeNotifier {
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

  void showProfileScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const ProfileScreenWidget(isMine: false)));
  }
  // MARK: -
  // MARK: - FUNCTIONS
}
