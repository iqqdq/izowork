import 'package:izowork/entities/response/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserParams {
  late SharedPreferences _sharedPreferences;

  void setToken(String token) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString('token', token);
  }

  void setUser(User user) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString('user', user.toJson().toString());
  }

  void setLocationPermission(bool isGranted) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setBool('location_permission', isGranted);
  }

  void clear() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.clear();
  }

  Future<String?> getToken() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getString('token');
  }

  Future<User> getUser() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    dynamic json = _sharedPreferences.get('user');
    return User.fromJson(json);
  }

  Future<bool?> getLocationPermission() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getBool('location_permission');
  }
}
