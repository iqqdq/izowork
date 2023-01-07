import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:izowork/components/loading_status.dart';

class NewsCreationViewModel with ChangeNotifier {
  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  File? _file;

  File? get file {
    return _file;
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void pickImage() async {
    final XFile? file =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      _file = File(file.path);
      notifyListeners();
    }
  }

  // MARK: -
  // MARK: - PUSH

}
