import 'package:izowork/models/models.dart';

abstract class LocalStorageRepositoryInterface {
  Future<String?> getToken();

  Future<User?> getUser();

  Future setToken(String token);

  Future setUser(User user);

  Future clear();
}
