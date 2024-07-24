import 'package:izowork/models/models.dart';

abstract class AuthorizationRepositoryInterface {
  Future<dynamic> login(AuthorizationRequest authorizationRequest);

  Future<dynamic> sendFcmToken(String fcmToken);
}
