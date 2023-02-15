import 'package:izowork/components/user_params.dart';
import 'package:izowork/entities/request/authorization_request.dart';
import 'package:izowork/entities/response/authorization.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/services/web_service.dart';

class AuthorizationRepository {
  Future<dynamic> login(AuthorizationRequest authorizationRequest) async {
    dynamic json = await WebService().post(loginUrl, authorizationRequest);

    if (json["token"] != null) {
      Authorization authorization = Authorization.fromJson(json);
      UserParams().setToken(authorization.token);
      return authorization;
    } else {
      return ErrorResponse.fromJson(json);
    }
  }
}
