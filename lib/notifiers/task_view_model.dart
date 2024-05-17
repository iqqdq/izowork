import 'dart:io' as io;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/helpers/helpers.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/api/api.dart';

class TaskViewModel with ChangeNotifier {
  final String id;

  LoadingStatus loadingStatus = LoadingStatus.empty;

  Task? _task;

  Task? get task => _task;

  int _downloadIndex = -1;

  int get downloadIndex => _downloadIndex;

  TaskViewModel(this.id) {
    getTaskById();
  }

  // MARK: -
  // MARK: - API CALL

  Future getTaskById() async {
    await TaskRepository()
        .getTask(id)
        .then((response) => {
              if (response is Task)
                {
                  _task = response,
                  loadingStatus = LoadingStatus.completed,
                }
              else
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => notifyListeners());
  }

  // MARK: -
  // MARK: - ACTIONS

  Future openFile(
    int index,
    VoidCallback onFileOpenError,
  ) async {
    if (_task == null) return;

    if (_task!.files[index].filename == null) return;

    String url = taskMediaUrl + _task!.files[index].filename!;

    if (Platform.isAndroid) {
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      String appDocumentsPath = appDocumentsDirectory.path;
      String fileName = _task!.files[index].name;
      String filePath = '$appDocumentsPath/$fileName';
      bool isFileExists = await io.File(filePath).exists();

      if (!isFileExists) {
        _downloadIndex = index;
        notifyListeners();

        await Dio().download(url, filePath).whenComplete(() => {
              _downloadIndex = -1,
              notifyListeners(),
            });
      }

      OpenResult openResult = await OpenFilex.open(filePath);

      if (openResult.type == ResultType.noAppToOpen) onFileOpenError();
    } else {
      WebViewHelper().openWebView(url);
    }
  }
}
