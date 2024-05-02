abstract class PushNotificationService {
  Future setupFlutterLocalNotificationsPlugin();

  Future getDeviceToken();

  Future deleteDeviceToken();
}
