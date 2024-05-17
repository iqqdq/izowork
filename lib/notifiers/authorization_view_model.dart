import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/screens/recovery/recovery_screen.dart';
import 'package:izowork/screens/tab_controller/tab_controller_screen.dart';

class AuthorizationViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.empty;

  // MARK: -
  // MARK: - API CALLS

  Future authorize(
    BuildContext context,
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
                    .whenComplete(() => getUserProfile(context))
              }
            else if (response is ErrorResponse)
              {
                loadingStatus = LoadingStatus.error,
                notifyListeners(),
                Toast().showTopToast(context, Titles.invalidLogin)
              }
          },
        );
  }

  Future getUserProfile(BuildContext context) async {
    await UserRepository()
        .getUser(null)
        .then((response) => {
              if (response is User)
                {
                  loadingStatus = LoadingStatus.completed,
                  notifyListeners(),

                  /// SAVE USER
                  GetIt.I<LocalStorageRepositoryInterface>()
                      .setUser(response)
                      .then((value) =>

                          /// SHOW TAB CONTROLLER SCREEN
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const TabControllerScreenWidget()),
                            (route) => false,
                          ))
                }
              else
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => notifyListeners());
  }

  // MARK: -
  // MARK: - PUSH

  void showRecoveryScreen(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const RecoveryScreenWidget()));
  }
}
