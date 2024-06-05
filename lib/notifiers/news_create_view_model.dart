// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';

class NewsCreateViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.empty;

  final List<File> _files = [];

  bool _important = false;

  int current = 0;

  List<File> get files => _files;

  bool get important => _important;

  // MARK: -
  // MARK: - API CALL

  Future createNewDeal(
    String name,
    String description,
    bool important,
    Function(News) onCreate,
  ) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await NewsRepository()
        .createNews(NewsRequest(
          description: description,
          important: important,
          name: name,
        ))
        .then((response) => {
              if (response is News)
                {
                  if (_files.isNotEmpty)
                    {
                      _files.forEach((element) async {
                        await uploadFile(
                          response.id,
                          element,
                        ).whenComplete(() => {
                              current++,
                              if (current == _files.length) onCreate(response)
                            });
                      })
                    }
                  else
                    onCreate(response)
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(response.message ?? 'Произошла ошибка')
                },
            })
        .whenComplete(() => notifyListeners());
  }

  Future uploadFile(
    String id,
    File file,
  ) async {
    await NewsRepository()
        .addNewsFile(NewsFileRequest(id, file))
        .then((response) => {
              if (response is NewsFile)
                loadingStatus = LoadingStatus.completed
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(response.message ?? 'Произошла ошибка')
                }
            });
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void pickImage() async {
    final XFile? file =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      _files.add(File(file.path));
      notifyListeners();
    }
  }

  void setInportant(bool important) {
    _important = important;
    notifyListeners();
  }
}
