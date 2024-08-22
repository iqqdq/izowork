import 'package:dio/dio.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';

abstract class UserRepositoryInterface {
  Future<dynamic> getUser(String? id);

  Future<dynamic> updateUser(UserRequest userRequest);

  Future<dynamic> updateAvatar(FormData formData);

  Future<dynamic> getUserRating(String id);

  Future<dynamic> getUsers({
    required Pagination pagination,
    String? search,
  });

  Future<dynamic> getParticipants({
    required Pagination pagination,
    required String id,
    String? search,
  });

  Future deleteUser({required String id});

  Future resetPassword(ResetPasswordRequest resetPasswordRequest);
}
