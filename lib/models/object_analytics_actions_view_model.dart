import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/screens/profile/profile_screen.dart';

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
            builder: (context) =>
                ProfileScreenWidget(user: null, onPop: (user) => null)));
  }
  // MARK: -
  // MARK: - FUNCTIONS
}
