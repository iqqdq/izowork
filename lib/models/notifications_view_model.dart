// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/response/deal.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/notification.dart';
import 'package:izowork/entities/response/object.dart';
import 'package:izowork/entities/response/task.dart';
import 'package:izowork/repositories/deal_repository.dart';
import 'package:izowork/repositories/notification_repository.dart';
import 'package:izowork/repositories/object_repository.dart';
import 'package:izowork/repositories/task_repository.dart';
import 'package:izowork/screens/deal/deal_screen.dart';
import 'package:izowork/screens/object/object_page_view_screen.dart';
import 'package:izowork/screens/task/task_screen.dart';

class NotificationsViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<NotificationEntity> _notifications = [];

  List<NotificationEntity> get notifications {
    return _notifications;
  }

  NotificationsViewModel() {
    getNotificationList(pagination: Pagination(offset: 0, size: 50));
  }

  // MARK: -
  // MARK: - API CALL

  Future getNotificationList({required Pagination pagination}) async {
    if (pagination.offset == 0) {
      loadingStatus = LoadingStatus.searching;
      _notifications.clear();

      Future.delayed(Duration.zero, () async {
        notifyListeners();
      });
    }

    await NotificationRepository()
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
        .then((value) => notifyListeners());
  }

  Future getObjectById(BuildContext context, String id) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await ObjectRepository().getObject(id).then((response) => {
          if (response is Object)
            {
              loadingStatus = LoadingStatus.completed,
              notifyListeners(),
              Future.delayed(
                  const Duration(milliseconds: 50),
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ObjectPageViewScreenWidget(object: response))))
            }
          else if (response is ErrorResponse)
            {loadingStatus = LoadingStatus.error, notifyListeners()}
        });
  }

  Future getDealById(BuildContext context, String id) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await DealRepository().getDeal(id).then((response) => {
          if (response is Deal)
            {
              loadingStatus = LoadingStatus.completed,
              notifyListeners(),
              Future.delayed(
                  const Duration(milliseconds: 50),
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DealScreenWidget(deal: response))))
            }
          else
            {loadingStatus = LoadingStatus.error, notifyListeners()}
        });
  }

  Future getTaskById(BuildContext context, String id) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await TaskRepository().getTask(id).then((response) => {
          if (response is Task)
            {
              loadingStatus = LoadingStatus.completed,
              notifyListeners(),
              Future.delayed(
                  const Duration(milliseconds: 50),
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TaskScreenWidget(task: response))))
            }
          else
            {loadingStatus = LoadingStatus.error, notifyListeners()}
        });
  }

  // MARK: -
  // MARK: - PUSH

  void showNotificationScreen(BuildContext context, int index) {
    if (_notifications[index].metadata.objectId != null) {
      getObjectById(context, _notifications[index].metadata.objectId!);
    } else if (_notifications[index].metadata.dealId != null) {
      getDealById(context, _notifications[index].metadata.dealId!);
    } else if (_notifications[index].metadata.taskId != null) {
      getTaskById(context, _notifications[index].metadata.taskId!);
    }
  }
}
