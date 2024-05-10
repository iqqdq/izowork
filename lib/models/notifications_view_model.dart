// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';

import 'package:izowork/entities/requests/requests.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/screens/deal/deal_screen.dart';
import 'package:izowork/screens/news_page/news_page_screen.dart';
import 'package:izowork/screens/object/object_page_view_screen.dart';
import 'package:izowork/screens/task/task_screen.dart';

class NotificationsViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<NotificationEntity> _notifications = [];

  List<NotificationEntity> get notifications => _notifications;

  NotificationsViewModel() {
    getNotificationList(pagination: Pagination(offset: 0, size: 50));
  }

  // MARK: -
  // MARK: - API CALL

  Future getNotificationList({required Pagination pagination}) async {
    if (pagination.offset == 0) {
      _notifications.clear();
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
        .whenComplete(() => notifyListeners());
  }

  Future readNotification(
    BuildContext context,
    bool isPushNotification,
    NotificationEntity notificationEntity,
  ) async {
    if (notificationEntity.read == true) {
      // SHOW OBJECT/DEAL/TASK SCREEN
      showNotificationScreen(
        context,
        notificationEntity,
      );
    } else {
      loadingStatus = LoadingStatus.searching;
      notifyListeners();

      await NotificationRepository()
          .read(
              readNotificationRequest:
                  ReadNotificationRequest(id: notificationEntity.id))
          .then((response) => {
                if (response == true)
                  {
                    if (!isPushNotification)
                      {
                        loadingStatus = LoadingStatus.completed,
                        notificationEntity.read = true,
                        notifyListeners(),
                      },

                    // SHOW OBJECT/DEAL/TASK SCREEN
                    Future.delayed(
                        Duration.zero,
                        () => showNotificationScreen(
                              context,
                              notificationEntity,
                            ))
                  }
                else
                  loadingStatus = LoadingStatus.error,
              })
          .whenComplete(() => notifyListeners());
    }
  }

  Future getObjectById(BuildContext context, String id) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await ObjectRepository().getObject(id).then((response) => {
          if (response is MapObject)
            {
              loadingStatus = LoadingStatus.completed,
              notifyListeners(),
              if (context.mounted)
                {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ObjectPageViewScreenWidget(object: response),
                      ))
                }
            }
          else if (response is ErrorResponse)
            {
              loadingStatus = LoadingStatus.error,
              notifyListeners(),
            }
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
              if (context.mounted)
                {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DealScreenWidget(deal: response)))
                }
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
              if (context.mounted)
                {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TaskScreenWidget(task: response)))
                }
            }
          else
            loadingStatus = LoadingStatus.error,
          notifyListeners()
        });
  }

  Future getNewsById(BuildContext context, String id) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await NewsRepository()
        .getNewsOne(id)
        .then((response) => {
              if (response is News)
                {
                  loadingStatus = LoadingStatus.completed,
                  notifyListeners(),
                  if (context.mounted)
                    {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewsPageScreenWidget(
                                    news: response,
                                    tag: '',
                                  )))
                    }
                }
              else
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(
          () => notifyListeners(),
        );
  }

  Future getPhaseById(
    BuildContext context,
    String objectId,
    String phaseId,
  ) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await PhaseRepository()
        .getPhase(phaseId)
        .then((phase) async => {
              if (phase is Phase)
                await ObjectRepository().getObject(objectId).then((object) => {
                      if (object is MapObject)
                        {
                          loadingStatus = LoadingStatus.completed,
                          notifyListeners(),
                          if (context.mounted)
                            {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ObjectPageViewScreenWidget(
                                            object: object,
                                            phase: phase,
                                          )))
                            }
                        }
                    })
              else
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(
          () => notifyListeners(),
        );
  }

  // MARK: -
  // MARK: - PUSH

  void showNotificationScreen(
    BuildContext context,
    NotificationEntity notificationEntity,
  ) {
    if (notificationEntity.metadata.objectId != null) {
      if (notificationEntity.metadata.phaseId != null) {
        getPhaseById(
          context,
          notificationEntity.metadata.objectId!,
          notificationEntity.metadata.phaseId!,
        );
      } else {
        getObjectById(
          context,
          notificationEntity.metadata.objectId!,
        );
      }
    } else if (notificationEntity.metadata.dealId != null) {
      getDealById(
        context,
        notificationEntity.metadata.dealId!,
      );
    } else if (notificationEntity.metadata.taskId != null) {
      getTaskById(
        context,
        notificationEntity.metadata.taskId!,
      );
    } else if (notificationEntity.metadata.newsId != null) {
      getNewsById(
        context,
        notificationEntity.metadata.newsId!,
      );
    }
  }
}
