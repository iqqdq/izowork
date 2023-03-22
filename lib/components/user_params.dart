import 'package:shared_preferences/shared_preferences.dart';

class UserParams {
  late SharedPreferences _sharedPreferences;

  Future<String?> getToken() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getString('token');
  }

  Future setToken(String token) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString('token', token);
  }

  Future<String?> getUserId() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getString('user_id');
  }

  Future setUserId(String id) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString('user_id', id);
  }

  Future<bool?> getLocationPermission() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getBool('location_permission');
  }

  Future setLocationPermission(bool isGranted) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setBool('location_permission', isGranted);
  }

  Future clear() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.clear();
  }
}
