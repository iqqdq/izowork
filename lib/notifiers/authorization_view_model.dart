import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';

class AuthorizationViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.empty;

  // MARK: -
  // MARK: - API CALLS

  Future authorize(
    String email,
    String password,
  ) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await AuthorizationRepository()
        .login(AuthorizationRequest(
          email: email,
          password: password,
        ))
        .then(
          (response) => {
            if (response is Authorization)
              {
                /// SAVE USER TOKEN
                GetIt.I<LocalStorageRepositoryInterface>()
                    .setToken(response.token)
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
    await UserRepository()
        .getUser(null)
        .then((response) async => {
              if (response is User)
                {
                  /// SAVE USER
                  await GetIt.I<LocalStorageRepositoryInterface>()
                      .setUser(response),

                  loadingStatus = LoadingStatus.completed
                }
              else
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => notifyListeners());
  }
}
