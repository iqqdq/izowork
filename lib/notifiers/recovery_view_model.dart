import 'package:flutter/material.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';

class RecoveryViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.empty;

  // MARK: -
  // MARK: - API CALL

  Future sendUserEmail(String email) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await UserRepository()
        .resetPassword(ResetPasswordRequest(email))
        .then((response) => {
              if (response == true)
                {
                  loadingStatus = LoadingStatus.completed,
                  Toast().showTopToast(Titles.passwordRecoverySuccess),
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(response.message ?? 'Ошибка'),
                }
            })
        .whenComplete(() => notifyListeners());
  }
}
