// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/request/news_file_request.dart';
import 'package:izowork/entities/request/news_request.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/news.dart';
import 'package:izowork/repositories/news_repository.dart';

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
    BuildContext context,
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
                        await uploadFile(context, response.id, element)
                            .whenComplete(() => {
                                  current++,
                                  if (current == _files.length)
                                    onCreate(response)
                                });
                      })
                    }
                  else
                    onCreate(response)
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
                },
            })
        .whenComplete(() => notifyListeners());
  }

  Future uploadFile(
    BuildContext context,
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
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
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
