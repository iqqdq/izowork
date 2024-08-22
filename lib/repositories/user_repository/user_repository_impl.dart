import 'package:dio/dio.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/services/services.dart';

import 'user_repository_interface.dart';

class UserRepositoryImpl implements UserRepositoryInterface {
  @override
  Future<dynamic> getUser(String? id) async {
    dynamic json = await await sl<WebServiceInterface>()
        .get(id == null ? profileUrl : userUrl + '?id=$id');

    try {
      User user = User.fromJson(json["user"]);
      return user;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> updateUser(UserRequest userRequest) async {
    dynamic json = await sl<WebServiceInterface>().patch(
      userUpdateUrl,
      userRequest.toJson(),
      null,
    );

    try {
      return User.fromJson(json["user"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> updateAvatar(FormData formData) async {
    dynamic json = await sl<WebServiceInterface>().put(
      uploadAvatarUrl,
      formData,
    );

    try {
      return json["avatar"] as String;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> getUserRating(String id) async {
    dynamic json =
        await await sl<WebServiceInterface>().get(userRatingUrl + '?id=$id');

    try {
      return json["rating"] as num;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> getUsers({
    required Pagination pagination,
    String? search,
  }) async {
    var url =
        usersUrl + '?offset=${pagination.offset}&limit=${pagination.size}';

    if (search != null) {
      url += '&q=$search';
    }

    dynamic json = await sl<WebServiceInterface>().get(url);

    List<User> users = [];

    try {
      json['users'].forEach((element) {
        users.add(User.fromJson(element));
      });
      return users;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> getParticipants({
    required Pagination pagination,
    required String id,
    String? search,
  }) async {
    var url = participants +
        '?offset=${pagination.offset}&limit=${pagination.size}&chat_id=$id';

    if (search != null) {
      url += '&q=$search';
    }

    dynamic json = await sl<WebServiceInterface>().get(url);

    List<User> users = [];

    try {
      json['users'].forEach((element) {
        users.add(User.fromJson(element));
      });
      return users;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future deleteUser({required String id}) async {
    dynamic json = await sl<WebServiceInterface>().delete(
      deleteAccountUrl,
      DeleteRequest(id: id),
    );

    if (json == null) {
      return true;
    } else {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future resetPassword(ResetPasswordRequest resetPasswordRequest) async {
    dynamic json = await sl<WebServiceInterface>().put(
      resetPasswordUrl,
      resetPasswordRequest.toJson(),
    );

    if (json == null || json == '' || json == true) {
      return true;
    } else {
      return ErrorResponse.fromJson(json);
    }
  }
}
