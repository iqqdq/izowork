import 'local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:izowork/entities/response/user.dart';
import 'dart:convert';

class LocalStorageServiceImpl extends LocalStorageService {
  final SharedPreferences sharedPreferences;

  LocalStorageServiceImpl({required this.sharedPreferences});

  @override
  Future<String?> getToken() async => sharedPreferences.getString('token');

  @override
  Future<User?> getUser() async => sharedPreferences.getString('user') == null
      ? null
      : User.fromJson(json.decode(sharedPreferences.getString('user')!));

  @override
  Future setToken(String token) async =>
      await sharedPreferences.setString('token', token);

  @override
  Future setUser(User user) async =>
      await sharedPreferences.setString('user', jsonEncode(user.toJson()));

  @override
  Future clear() async => await sharedPreferences.clear();
}
