import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';

abstract class NotificationRepositoryInterface {
  Future<dynamic> getNotifications({required Pagination pagination});

  Future<dynamic> getNotificationUnreadCount();

  Future<dynamic> read(
      {required ReadNotificationRequest readNotificationRequest});
}
