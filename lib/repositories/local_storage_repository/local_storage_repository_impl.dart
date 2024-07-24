import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'local_storage_repository.dart';

class LocalStorageRepositoryImpl extends LocalStorageRepositoryInterface {
  final SharedPreferences sharedPreferences;

  LocalStorageRepositoryImpl({required this.sharedPreferences});

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
