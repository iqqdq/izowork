import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:url_launcher/url_launcher.dart';

class StaffViewModel with ChangeNotifier {
  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  // MARK: -
  // MARK: - FUNCTIONS

  // MARK: -
  // MARK: - ACTIONS

  void openUrl(String url) {
    launchUrl(Uri.parse((url)));
  }
}
