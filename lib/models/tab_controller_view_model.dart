import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/repositories/chat_repository.dart';
import 'package:izowork/repositories/notification_repository.dart';

class TabControllerViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  int _messageCount = 0;

  int _notificationCount = 0;

  int get messageCount {
    return _messageCount;
  }

  int get notificationCount {
    return _notificationCount;
  }

  TabControllerViewModel() {
    getUnreadMessageCount()
        .then((value) => getUnreadNotificationCount().then((value) => {
              loadingStatus = LoadingStatus.completed,
              notifyListeners(),
            }));
  }

  // MARK: -
  // MARK: - API CALLS

  Future getUnreadMessageCount() async {
    await ChatRepository().getUnreadMessageCount().then((response) => {
          if (response is int)
            {
              _messageCount = response,
              notifyListeners(),
            }
        });
  }

  Future getUnreadNotificationCount() async {
    await NotificationRepository()
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

  void clearMessageBadge() {
    _messageCount = 0;
    notifyListeners();
  }

  void clearNotificationBadge() {
    _notificationCount = 0;
    notifyListeners();
  }
}
