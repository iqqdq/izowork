import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/notification.dart';
import 'package:izowork/entities/request/read_notification_request.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/services/web_service.dart';

class NotificationRepository {
  Future<dynamic> getNotifications({required Pagination pagination}) async {
    var url = notificationUrl +
        '?offset=${pagination.offset}&limit=${pagination.size}';

    dynamic json = await WebService().get(url);

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

  Future<dynamic> getNotificationUnreadCount() async {
    dynamic json = await WebService().get(notificationUnreadCountUrl);

    try {
      return json['count'] as int;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> read(
      {required ReadNotificationRequest readNotificationRequest}) async {
    dynamic json =
        await WebService().put(readNotificationUrl, readNotificationRequest);

    if (json == true || json == '') {
      return true;
    } else {
      return ErrorResponse.fromJson(json).message ?? 'Ошибка';
    }
  }
}
