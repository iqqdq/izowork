import 'package:flutter/material.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AuthorizationViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.empty;

  void showPrivacyPolicy() => launchUrlString(privacyPolicyUrl);

  // MARK: -
  // MARK: - API CALLS

  Future authorize(
    String email,
    String password,
  ) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<AuthorizationRepositoryInterface>()
        .login(AuthorizationRequest(
          email: email,
          password: password,
        ))
        .then(
          (response) => {
            if (response is Authorization)
              {
                /// SAVE USER TOKEN
                sl<LocalStorageRepositoryInterface>().setToken(response.token)
              }
            else if (response is ErrorResponse)
              {
                loadingStatus = LoadingStatus.error,
                Toast().showTopToast(Titles.invalidLogin)
              }
          },
        )
        .whenComplete(() => notifyListeners());
  }

  Future getUserProfile() async {
    await sl<UserRepositoryInterface>()
        .getUser(null)
        .then((response) async => {
              if (response is User)
                {
                  /// SAVE USER
                  await sl<LocalStorageRepositoryInterface>().setUser(response),

                  loadingStatus = LoadingStatus.completed
                }
              else
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => notifyListeners());
  }
}
