import 'package:flutter/material.dart';

import 'package:izowork/helpers/helpers.dart';
import 'package:izowork/components/components.dart';
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

  Future openFile(int index) async {
    if (_task!.files[index].filename == null) return;
    final filename = _task!.files[index].filename!;

    FileDownloadHelper().download(
        url: taskMediaUrl + filename,
        filename: filename,
        onDownload: () => {
              _downloadIndex = index,
              notifyListeners(),
            },
        onComplete: () => {
              _downloadIndex = -1,
              notifyListeners(),
            });
  }
}
