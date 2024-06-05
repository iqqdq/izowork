// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

import 'package:izowork/helpers/helpers.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/api/api.dart';

class TaskCreateViewModel with ChangeNotifier {
  final Task? task;

  final DateTime _minDateTime = DateTime(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .year -
          5,
      1,
      1);

  final DateTime _maxDateTime = DateTime(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .year +
          5,
      1,
      1);

  bool isUpdated = false;

  LoadingStatus loadingStatus = LoadingStatus.empty;

  TaskState? _taskState;

  String? _state;

  DateTime _pickedDateTime =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  User? _taskManager;

  User? _responsible;

  User? _coExecutor;

  MapObject? _object;

  Company? _company;

  List<Document> _documents = [];

  final List<File> _files = [];

  int _downloadIndex = -1;

  int current = 0;

  TaskState? get taskState => _taskState;

  String? get state => _state;

  User? get responsible => _responsible;

  User? get taskManager => _taskManager;

  User? get coExecutor => _coExecutor;

  MapObject? get object => _object;

  Company? get company => _company;

  DateTime get minDateTime => _minDateTime;

  DateTime get maxDateTime => _maxDateTime;

  DateTime get pickedDateTime => _pickedDateTime;

  List<Document> get documents => _documents;

  List<File> get files => _files;

  int get downloadIndex => _downloadIndex;

  TaskCreateViewModel(this.task) {
    if (task != null) {
      _pickedDateTime = DateTime.parse(task!.deadline);

      if (task!.files.isNotEmpty) _documents = task!.files;
      isUpdated = true;
    }

    getTaskStateList();
  }

  // MARK: -
  // MARK: - API CALL

  Future getTaskStateList() async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await TaskRepository()
        .getTaskStates()
        .then((response) => {
              if (response is TaskState)
                {
                  loadingStatus = LoadingStatus.completed,
                  _taskState = response,
                }
              else if (response is ErrorResponse)
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => notifyListeners());
  }

  Future createNewTask(
    String name,
    String? description,
    Function(Task) onCreate,
  ) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await TaskRepository()
        .createTask(TaskRequest(
            deadline: _pickedDateTime.toUtc().toLocal().toIso8601String() + 'Z',
            name: name,
            description: description,
            state: _state!,
            taskManagerId: _taskManager?.id,
            coExecutorId: _coExecutor?.id,
            companyId: _company?.id,
            responsibleId: responsible?.id,
            objectId: object?.id))
        .then((response) => {
              if (response is Task)
                {
                  if (_files.isNotEmpty)
                    {
                      _files.forEach((element) async {
                        await uploadFile(response.id, element).whenComplete(
                            () => {
                                  current++,
                                  if (current == _files.length)
                                    onCreate(response)
                                });
                      })
                    }
                  else
                    onCreate(response)
                }
            })
        .whenComplete(() => notifyListeners());
  }

  Future editTask(
    String name,
    String? description,
    Function(Task) onCreate,
  ) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await TaskRepository()
        .updateTask(TaskRequest(
          id: task!.id,
          deadline: _pickedDateTime.toUtc().toLocal().toIso8601String() + 'Z',
          name: name,
          description: description,
          state: _state ?? task!.state,
          taskManagerId: _taskManager?.id ?? task!.taskManager?.id,
          coExecutorId: _coExecutor?.id ?? task!.coExecutor?.id,
          companyId: _company?.id ?? task!.company?.id,
          responsibleId: responsible?.id ?? task!.responsible?.id,
          objectId: object?.id ?? task!.object?.id,
        ))
        .then((response) => {
              if (response is Task) onCreate(response),
            })
        .whenComplete(() => notifyListeners());
  }

  Future uploadFile(
    String id,
    File file,
  ) async {
    await TaskRepository()
        .addTaskFile(TaskFileRequest(id, file))
        .then((response) => {
              if (response is Document)
                {
                  loadingStatus = LoadingStatus.completed,
                  _documents.add(response)
                }
            })
        .whenComplete(() => notifyListeners());
  }

  Future deleteTaskFile(int index) async {
    if (task == null) {
      _files.removeAt(index);
      notifyListeners();
    } else {
      loadingStatus = LoadingStatus.searching;
      notifyListeners();

      await TaskRepository()
          .deleteTaskFile(DeleteRequest(id: task!.files[index].id))
          .then((response) => {
                if (response == true)
                  {
                    loadingStatus = LoadingStatus.completed,
                    _documents.removeAt(index)
                  }
              })
          .whenComplete(() => notifyListeners());
    }
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void changeUser(
    int index,
    User? user,
  ) {
    index == 1
        ? _taskManager = user
        : index == 2
            ? _coExecutor = user
            : _responsible = user;

    notifyListeners();
  }

  void changeState(String state) {
    _state = state;
    notifyListeners();
  }

  void changeDateTime(DateTime dateTime) {
    _pickedDateTime = dateTime;
    notifyListeners();
  }

  void changeObject(MapObject? object) {
    _object = object;
    notifyListeners();
  }

  void changeCompany(Company? company) {
    _company = company;
    notifyListeners();
  }

  Future addFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc'],
    );

    if (result != null) {
      if (result.files.isNotEmpty) {
        if (task == null) {
          result.files.forEach((element) {
            if (element.path != null) {
              _files.add(File(element.path!));
              notifyListeners();
            }
          });
        } else {
          loadingStatus = LoadingStatus.searching;
          notifyListeners();

          result.files.forEach((element) async {
            if (element.path != null) {
              await uploadFile(
                task!.id,
                File(element.path!),
              ).then((value) => {
                    current++,
                    if (current == result.files.length)
                      {
                        loadingStatus = LoadingStatus.completed,
                        notifyListeners()
                      }
                  });
            }
          });
        }
      }
    }
  }

  Future openFile(int index) async {
    if (task == null) {
      if ((await OpenFilex.open(_files[index].path)).type ==
          ResultType.noAppToOpen) {
        Toast().showTopToast(Titles.unsupportedFileFormat);
      }
    } else {
      final filename = task!.files[index].filename;
      if (filename == null) return;

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
}
