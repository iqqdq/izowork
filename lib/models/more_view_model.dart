import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/services/local_storage/local_storage.dart';
import 'package:izowork/services/push_notification/push_notification.dart';

class MoreViewModel with ChangeNotifier {
  final int count;

  final GetIt _getIt = GetIt.I;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  User? _user;

  int _notificationCount = 0;

  int get notificationCount => _notificationCount;

  User? get user => _user;

  MoreViewModel(this.count) {
    _notificationCount = count;

    getProfile();
  }

  // MARK: -
  // MARK: - API CALL

  Future getProfile() async {
    loadingStatus = LoadingStatus.searching;

    await UserRepository()
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

  void updateUser(User user) {
    _user = user;
    notifyListeners();
  }

  Future logout() async {
    /// CLEAR LOCAL STORAGE
    await _getIt<LocalStorageService>().clear();

    /// DELETE DEVICE TOKEN
    await _getIt<PushNotificationService>().deleteDeviceToken();
  }
}
