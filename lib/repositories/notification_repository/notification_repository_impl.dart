import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/services/services.dart';

import 'notification_repository_interface.dart';

class NotificationRepositoryImpl implements NotificationRepositoryInterface {
  @override
  Future<dynamic> getNotifications({required Pagination pagination}) async {
    var url = notificationUrl +
        '?offset=${pagination.offset}&limit=${pagination.size}';

    dynamic json = await sl<WebServiceInterface>().get(url);

    List<NotificationEntity> notifications = [];

    try {
      json['notifications'].forEach((element) {
        notifications.add(NotificationEntity.fromJson(element));
      });
      return notifications;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> getNotificationUnreadCount() async {
    dynamic json =
        await sl<WebServiceInterface>().get(notificationUnreadCountUrl);

    try {
      return json['count'] as int;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> read(
      {required ReadNotificationRequest readNotificationRequest}) async {
    dynamic json = await sl<WebServiceInterface>().put(
      readNotificationUrl,
      readNotificationRequest.toJson(),
    );

    if (json == true || json == '') {
      return true;
    } else {
      return ErrorResponse.fromJson(json);
    }
  }
}
