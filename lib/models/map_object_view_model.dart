import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/screens/dialog/dialog_screen.dart';

class MapObjectViewModel with ChangeNotifier {
  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  // MARK: -
  // MARK: - FUNCTIONS

  // MARK: -
  // MARK: - PUSH

  void showObjectScreen(BuildContext context) {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => ObjectScreenWidget(object: Object())));
  }

  void showDialogScreen(BuildContext context) {
    // Navigator.push(context,
    //     MaterialPageRoute(builder: (context) => const DialogScreenWidget()));
  }
}
