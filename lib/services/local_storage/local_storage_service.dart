import 'package:izowork/entities/responses/responses.dart';

abstract class LocalStorageService {
  Future<String?> getToken();

  Future<User?> getUser();

  Future setToken(String token);

  Future setUser(User user);

  Future clear();
}
