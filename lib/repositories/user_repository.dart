import 'package:dio/dio.dart';
import 'package:izowork/components/components.dart';

import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/services/web_service.dart';

class UserRepository {
  Future<dynamic> getUser(String? id) async {
    dynamic json =
        await WebService().get(id == null ? profileUrl : userUrl + '?id=$id');

    try {
      User user = User.fromJson(json["user"]);
      return user;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> updateUser(UserRequest userRequest) async {
    dynamic json = await WebService().patch(
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

  Future<dynamic> updateAvatar(FormData formData) async {
    dynamic json = await WebService().put(
      uploadAvatarUrl,
      formData,
    );

    try {
      return json["avatar"] as String;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> getUsers({
    required Pagination pagination,
    String? search,
  }) async {
    var url =
        usersUrl + '?offset=${pagination.offset}&limit=${pagination.size}';

    if (search != null) {
      url += '&q=$search';
    }

    dynamic json = await WebService().get(url);

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

    dynamic json = await WebService().get(url);

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

  Future deleteUser({required String id}) async {
    dynamic json = await WebService().delete(
      deleteAccountUrl,
      DeleteRequest(id: id),
    );

    if (json == null) {
      return true;
    } else {
      return ErrorResponse.fromJson(json);
    }
  }

  Future resetPassword(ResetPasswordRequest resetPasswordRequest) async {
    dynamic json = await WebService().put(
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
