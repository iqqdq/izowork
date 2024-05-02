import 'package:izowork/entities/response/user.dart';

abstract class LocalStorageService {
  Future<String?> getToken();

  Future<User?> getUser();

  Future setToken(String token);

  Future setUser(User user);

  Future clear();
}
