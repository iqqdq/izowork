import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/repositories/repositories.dart';

class MoreViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  User? _user;

  int? _notificationCount;

  int? get notificationCount => _notificationCount;

  User? get user => _user;

  MoreViewModel() {
    if (_notificationCount == null) {
      getUnreadNotificationCount();
    }

    getProfile();
  }

  // MARK: -
  // MARK: - API CALL

  Future getProfile() async {
    loadingStatus = LoadingStatus.searching;

    await sl<UserRepositoryInterface>()
        .getUser(null)
        .then((response) => {
              if (response is User)
                {
                  _user = response,
                  loadingStatus = LoadingStatus.completed,
                }
              else
                loadingStatus = LoadingStatus.error,
            })
        .then((value) => notifyListeners());
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

  void updateUser(User user) {
    _user = user;

    Future.delayed(const Duration(milliseconds: 300), () => notifyListeners());
  }

  Future logout() async => await sl<LocalStorageRepositoryInterface>().clear();
}
