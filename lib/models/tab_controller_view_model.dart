import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/services/push_notification/push_notification.dart';

class TabControllerViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  int _messageCount = 0;

  int _notificationCount = 0;

  int get messageCount => _messageCount;

  int get notificationCount => _notificationCount;

  TabControllerViewModel() {
    _updateDeviceToken().whenComplete(
      () => getUnreadMessageCount().then(
        (value) => getUnreadNotificationCount().then((value) => {
              loadingStatus = LoadingStatus.completed,
              notifyListeners(),
            }),
      ),
    );
  }

  // MARK: -
  // MARK: - API CALLS

  Future _updateDeviceToken() async {
    // GET DEVICE TOKEN FROM FIREBASE
    await GetIt.I<PushNotificationService>()
        .getDeviceToken()
        .then((value) async {
      if (value == null) return;
      // CALL API TO SAVE SEVICE TOKEN
      await FcmTokenRepository().sendDeviceToken(value);
    });
  }

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
