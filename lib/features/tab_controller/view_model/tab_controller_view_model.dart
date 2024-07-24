import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/repositories/repositories.dart';

class TabControllerViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  int _messageCount = 0;

  int _notificationCount = 0;

  int get messageCount => _messageCount;

  int get notificationCount => _notificationCount;

  TabControllerViewModel() {
    getUnreadMessageCount().whenComplete(() => getUnreadNotificationCount());
  }

  // MARK: -
  // MARK: - API CALLS

  Future updateFcmToken(String? fcmToken) async {
    if (fcmToken == null) return;
    await sl<AuthorizationRepositoryInterface>().sendFcmToken(fcmToken);
  }

  Future getUnreadMessageCount() async {
    await sl<ChatRepositoryInterface>()
        .getUnreadMessageCount()
        .then((response) => {
              if (response is int)
                _messageCount = response
              else
                _messageCount = 0
            })
        .whenComplete(() => notifyListeners());
  }

  Future getUnreadNotificationCount() async {
    await sl<NotificationRepositoryInterface>()
        .getNotificationUnreadCount()
        .then((response) => {
              if (response is int)
                {
                  _notificationCount = response,
                  notifyListeners(),
                }
            });
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void clearMessageCount() {
    _messageCount = 0;
    notifyListeners();
  }

  void clearNotificationCount() {
    _notificationCount = 0;
    notifyListeners();
  }
}
