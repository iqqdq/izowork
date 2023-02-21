import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/response/task.dart';
import 'package:izowork/repositories/task_repository.dart';
import 'package:izowork/screens/task_create/task_create_screen.dart';
import 'package:izowork/services/urls.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' as io;

class TaskViewModel with ChangeNotifier {
  final Task selectedTask;

  LoadingStatus loadingStatus = LoadingStatus.empty;

  Task? _task;

  int _downloadIndex = -1;

  Task? get task {
    return _task;
  }

  int get downloadIndex {
    return _downloadIndex;
  }

  TaskViewModel(this.selectedTask);

  // MARK: -
  // MARK: - API CALL

  Future getTaskById(String id) async {
    await TaskRepository().getTask(id).then((response) => {
          if (response is Task)
            {
              _task = response,
              loadingStatus = LoadingStatus.completed,
            }
          else
            {loadingStatus = LoadingStatus.error},
          notifyListeners()
        });
  }

  // MARK: -
  // MARK: - ACTIONS

  Future openFile(BuildContext context, int index) async {
    String url = taskMediaUrl +
        (_task?.files[index].filename ?? selectedTask.files[index].filename);

    if (Platform.isAndroid) {
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      String appDocumentsPath = appDocumentsDirectory.path;
      String fileName =
          _task?.files[index].name ?? selectedTask.files[index].name;
      String filePath = '$appDocumentsPath/$fileName';
      bool isFileExists = await io.File(filePath).exists();

      if (!isFileExists) {
        _downloadIndex = index;
        notifyListeners();

        await Dio().download(url, filePath, onReceiveProgress: (count, total) {
          debugPrint('---Download----Rec: $count, Total: $total');
        }).then((value) => {_downloadIndex = -1, notifyListeners()});
      }

      OpenResult openResult = await OpenFilex.open(filePath);

      if (openResult.type == ResultType.noAppToOpen) {
        Toast().showTopToast(context, Titles.unsupportedFileFormat);
      }
    } else {
      if (await canLaunchUrl(Uri.parse(url.replaceAll(' ', '')))) {
        launchUrl(Uri.parse(url.replaceAll(' ', '')));
      } else if (await canLaunchUrl(
          Uri.parse('https://' + url.replaceAll(' ', '')))) {
        launchUrl(Uri.parse('https://' + url.replaceAll(' ', '')));
      }
    }
  }

  // MARK: -
  // MARK: - PUSH

  void showTaskCreateScreenSheet(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TaskCreateScreenWidget(
                task: selectedTask,
                onCreate: (task) => getTaskById(selectedTask.id))));
  }
}
