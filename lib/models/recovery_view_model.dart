import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/request/reset_password_request.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/repositories/user_repository.dart';

class RecoveryViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.empty;

  // MARK: -
  // MARK: - API CALL

  Future sendUserEmail(BuildContext context, String email) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await UserRepository()
        .resetPassword(ResetPasswordRequest(email))
        .then((response) => {
              if (response == true)
                {
                  loadingStatus = LoadingStatus.completed,
                  Navigator.pop(context),
                  Toast().showTopToast(context, Titles.passwordRecoverySuccess),
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(context, response.message ?? 'Ошибка'),
                }
            })
        .whenComplete(() => notifyListeners());
  }
}
