import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/services/web_service.dart';

class AuthorizationRepository {
  Future<dynamic> login(AuthorizationRequest authorizationRequest) async {
    dynamic json = await WebService().post(
      loginUrl,
      authorizationRequest.toJson(),
    );

    if (json["token"] != null) {
      return Authorization.fromJson(json);
    } else {
      return ErrorResponse.fromJson(json);
    }
  }
}
