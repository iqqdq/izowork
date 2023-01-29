import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/object.dart';
import 'package:izowork/screens/dialog/dialog_screen.dart';
import 'package:izowork/screens/object_analytics/object_analytics_page_view_screen.dart';
import 'package:izowork/screens/object_create/object_create_screen.dart';

class ObjectViewModel with ChangeNotifier {
  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  // MARK: -
  // MARK: - ACTIONS

  void copyCoordinates(BuildContext context) {
    Clipboard.setData(const ClipboardData(text: '49.359212, 55.230101'))
        .then((value) => Toast().showTopToast(context, Titles.didCopied));
  }

  // MARK: -
  // MARK: - PUSH

  void showObjectCreateScreenSheet(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ObjectCreateScreenWidget(object: Object())));
  }

  void showDialogScreen(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const DialogScreenWidget()));
  }

  void showObjectAnalyticsPageViewScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const ObjectAnalyticsPageViewScreenBodyWidget()));
  }
}
