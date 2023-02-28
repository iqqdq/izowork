import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/request/user_request.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/user.dart';
import 'package:izowork/services/urls.dart';
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
    dynamic json =
        await WebService().patch(userUpdateUrl, jsonEncode(userRequest));

    try {
      return User.fromJson(json["user"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> updateAvatar(FormData formData) async {
    dynamic json = await WebService().put(uploadAvatarUrl, formData);

    try {
      return json["avatar"] as String;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> getUsers(
      {required Pagination pagination, String? search}) async {
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
}
