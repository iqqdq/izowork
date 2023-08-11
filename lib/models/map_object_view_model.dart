// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/entities/response/object.dart';
import 'package:izowork/screens/dialog/dialog_screen.dart';
import 'package:izowork/screens/object/object_page_view_screen.dart';

class MapObjectViewModel with ChangeNotifier {
  final Object object;

  final List<String> _urls = [];

  MapObjectViewModel(this.object) {
    getObjectImages();
  }

  List<String> get urls {
    return _urls;
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future getObjectImages() async {
    if (object.files.isNotEmpty) {
      object.files.forEach((element) {
        if (element.mimeType != null) {
          if (element.mimeType!.contains('image')) {
            _urls.add(element.filename ?? '');
          }
        }
      });
    }

    notifyListeners();
  }

  // MARK: -
  // MARK: - PUSH

  void showObjectScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ObjectPageViewScreenWidget(object: object)));
  }

  void showDialogScreen(BuildContext context) {
    if (object.chat != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DialogScreenWidget(chat: object.chat!)));
    }
  }
}
