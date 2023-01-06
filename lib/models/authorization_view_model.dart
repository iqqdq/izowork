import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/screens/recovery/recovery_screen.dart';
import 'package:izowork/screens/tab_controller/tab_controller_screen_body.dart';

class AuthorizationViewModel with ChangeNotifier {
  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  // MARK: -
  // MARK: - FUNCTIONS

  // MARK: -
  // MARK: - PUSH

  void showRecoveryScreen(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const RecoveryScreenWidget()));
  }

  void showTabControllerScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const TabControllerScreenWidget()));
  }
}
