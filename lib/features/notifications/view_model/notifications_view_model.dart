// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/repositories/repositories.dart';

class NotificationsViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<NotificationEntity> _notifications = [];

  List<NotificationEntity> get notifications => _notifications;

  NotificationsViewModel() {
    getNotificationList(pagination: Pagination());
  }

  // MARK: -
  // MARK: - API CALL

  Future getNotificationList({required Pagination pagination}) async {
    if (pagination.offset == 0) {
      _notifications.clear();
    }

    await sl<NotificationRepositoryInterface>()
        .getNotifications(pagination: pagination)
        .then((response) => {
              if (response is List<NotificationEntity>)
                {
                  if (_notifications.isEmpty)
                    {
                      response.forEach((notification) {
                        _notifications.add(notification);
                      })
                    }
                  else
                    {
                      response.forEach((newNotification) {
                        bool found = false;

                        _notifications.forEach((notification) {
                          if (newNotification.id == notification.id) {
                            found = true;
                          }
                        });

                        if (!found) {
                          _notifications.add(newNotification);
                        }
                      })
                    },
                  loadingStatus = LoadingStatus.completed
                }
              else
                loadingStatus = LoadingStatus.error
            })
        .whenComplete(() => notifyListeners());
  }

  Future readNotification(NotificationEntity notificationEntity) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<NotificationRepositoryInterface>()
        .read(
            readNotificationRequest:
                ReadNotificationRequest(id: notificationEntity.id))
        .then((response) => {
              if (response == true)
                {
                  loadingStatus = LoadingStatus.completed,
                  notificationEntity.read = true,
                }
            })
        .whenComplete(() => notifyListeners());
  }
}
