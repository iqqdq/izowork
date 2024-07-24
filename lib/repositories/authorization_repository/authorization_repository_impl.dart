import 'dart:convert';

import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/services/services.dart';

import 'authorization_repository.dart';

class AuthorizationRepositoryImpl implements AuthorizationRepositoryInterface {
  @override
  Future<dynamic> login(AuthorizationRequest authorizationRequest) async {
    dynamic json = await sl<WebServiceInterface>().post(
      loginUrl,
      authorizationRequest.toJson(),
    );

    if (json["token"] != null) {
      return Authorization.fromJson(json);
    } else {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> sendFcmToken(String fcmToken) async =>
      await sl<WebServiceInterface>().patch(
        fcmTokenUrl,
        [],
        jsonEncode({"token": fcmToken}),
      );
}
