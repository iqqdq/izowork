import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/components/user_params.dart';
import 'package:izowork/entities/request/authorization_request.dart';
import 'package:izowork/entities/response/authorization.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/user.dart';
import 'package:izowork/repositories/authorization_repository.dart';
import 'package:izowork/repositories/user_repository.dart';
import 'package:izowork/screens/recovery/recovery_screen.dart';
import 'package:izowork/screens/tab_controller/tab_controller_screen.dart';
import 'package:izowork/screens/tab_controller/tab_controller_screen_body.dart';

class AuthorizationViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.empty;

  // MARK: -
  // MARK: - API CALLS

  Future authorize(BuildContext context, String email, String password) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await AuthorizationRepository()
        .login(AuthorizationRequest(email: email, password: password))
        .then((response) => {
              if (response is Authorization)
                {
                  // SAVE USER TOKEN
                  UserParams().setToken(response.token),
                  getUserProfile(context)
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  notifyListeners(),
                  Toast().showTopToast(
                      context, response.message ?? Titles.invalidLogin)
                }
            });
  }

  Future getUserProfile(BuildContext context) async {
    await UserRepository().getUser(null).then((response) => {
          if (response is User)
            {
              loadingStatus = LoadingStatus.completed,
              notifyListeners(),

              // SAVE USER
              UserParams().setUserId(response.id).then((value) =>
                  // SHOW MAIN SREEN
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const TabControllerScreenWidget()),
                      (route) => false))
            }
          else
            {loadingStatus = LoadingStatus.error, notifyListeners()}
        });
  }

  // MARK: -
  // MARK: - PUSH

  void showRecoveryScreen(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const RecoveryScreenWidget()));
  }
}
