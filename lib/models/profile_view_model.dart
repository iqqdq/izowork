import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/screens/profile_edit/profile_edit_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfileViewModel with ChangeNotifier {
  final bool isMine;

  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  ProfileViewModel(this.isMine);

  // MARK: -
  // MARK: - ACTIONS

  void showProfileEditScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const ProfileEditScreenWidget()));
  }

  void openSocialUrl(String url) async {
    if (await canLaunchUrl(Uri(path: url))) {
      launchUrl(Uri(path: url));
    } else if (await canLaunchUrlString(url)) {
      launchUrlString(url);
    }
  }
}
