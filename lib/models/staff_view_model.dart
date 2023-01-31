import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/screens/dialog/dialog_screen.dart';
import 'package:izowork/screens/profile/profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class StaffViewModel with ChangeNotifier {
  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  // MARK: -
  // MARK: - PUSH

  void showProfileScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const ProfileScreenWidget(isMine: false)));
  }

  void showDialogScreen(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const DialogScreenWidget()));
  }

  // MARK: -
  // MARK: - ACTIONS

  void openUrl(String url) {
    launchUrl(Uri.parse((url)));
  }

  // MARK: -
  // MARK: - FUNCTIONS
}
