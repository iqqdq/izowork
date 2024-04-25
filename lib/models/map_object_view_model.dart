import 'package:flutter/material.dart';
import 'package:izowork/entities/response/object.dart';

class MapObjectViewModel with ChangeNotifier {
  final Object object;

  final List<String> _urls = [];

  MapObjectViewModel(this.object) {
    getObjectImages();
  }

  List<String> get urls => _urls;

  // MARK: -
  // MARK: - FUNCTIONS

  Future getObjectImages() async {
    if (object.files.isNotEmpty) {
      for (var element in object.files) {
        if (element.mimeType != null) {
          if (element.mimeType!.contains('image')) {
            _urls.add(element.filename ?? '');
          }
        }
      }
    }

    notifyListeners();
  }
}
