import 'dart:convert';

import 'package:izowork/entities/response/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalService {
  late SharedPreferences _sharedPreferences;

  Future<String?> getToken() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getString('token');
  }

  Future setToken(String token) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString(
      'token',
      token,
    );
  }

  Future setDeviceToken(String deviceToken) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString(
      'device_token',
      deviceToken,
    );
  }

  Future<User?> getUser() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    Map<String, dynamic>? map;
    String? encodedString = _sharedPreferences.getString('user');

    if (encodedString != null) {
      map = json.decode(encodedString);
    }

    return map == null ? null : User.fromJson(map);
  }

  Future setUser(User user) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString(
        'user',
        jsonEncode(
          user.toJson(),
        ));
  }

  Future<bool?> getLocationPermission() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getBool('location_permission');
  }

  Future setLocationPermission(bool isGranted) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setBool(
      'location_permission',
      isGranted,
    );
  }

  Future clear() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.clear();
  }
}
