// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/locale.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/request/delete_request.dart';
import 'package:izowork/entities/request/task_file_request.dart';
import 'package:izowork/entities/request/task_request.dart';
import 'package:izowork/entities/response/company.dart';
import 'package:izowork/entities/response/document.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/object.dart';
import 'package:izowork/entities/response/task.dart';
import 'package:izowork/entities/response/task_state.dart';
import 'package:izowork/entities/response/user.dart';
import 'package:izowork/repositories/task_repository.dart';
import 'package:izowork/screens/search_company/search_company_screen.dart';
import 'package:izowork/screens/search_object/search_object_screen.dart';
import 'package:izowork/screens/search_user/search_user_screen.dart';
import 'package:izowork/screens/selection/selection_screen.dart';
import 'package:izowork/api/urls.dart';
import 'package:izowork/views/date_time_wheel_picker_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

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

  Object? _object;

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

  Object? get object => _object;

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

      if (task!.files.isNotEmpty) {
        _documents = task!.files;
      }

      isUpdated = true;

      notifyListeners();
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
    BuildContext context,
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

  Future editTask(
    BuildContext context,
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
              if (response is Task)
                onCreate(response)
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
    await TaskRepository()
        .addTaskFile(TaskFileRequest(id, file))
        .then((response) => {
              if (response is Document)
                {
                  loadingStatus = LoadingStatus.completed,
                  _documents.add(response)
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
                }
            })
        .whenComplete(() => notifyListeners());
  }

  Future deleteTaskFile(BuildContext context, int index) async {
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
                else if (response is ErrorResponse)
                  {
                    loadingStatus = LoadingStatus.error,
                    Toast().showTopToast(context, response.message ?? 'Ошибка')
                  },
              })
          .whenComplete(() => notifyListeners());
    }
  }

  // MARK: -
  // MARK: - ACTIONS

  Future addFile(BuildContext context) async {
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
              await uploadFile(context, task!.id, File(element.path!))
                  .then((value) => {
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

  Future openFile(BuildContext context, int index) async {
    if (task == null) {
      OpenResult openResult = await OpenFilex.open(_files[index].path);

      if (openResult.type == ResultType.noAppToOpen) {
        Toast().showTopToast(context, Titles.unsupportedFileFormat);
      }
    } else {
      String url = taskMediaUrl + (task!.files[index].filename ?? '');

      if (Platform.isAndroid) {
        Directory appDocumentsDirectory =
            await getApplicationDocumentsDirectory();
        String appDocumentsPath = appDocumentsDirectory.path;
        String fileName = task!.files[index].name;
        String filePath = '$appDocumentsPath/$fileName';
        bool isFileExists = await io.File(filePath).exists();

        if (!isFileExists) {
          _downloadIndex = index;
          notifyListeners();

          await Dio().download(url, filePath,
              onReceiveProgress: (count, total) {
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
  }

  // MARK: -
  // MARK: - PUSH

  void showSelectionSheet(BuildContext context) {
    if (_taskState != null) {
      if (_taskState!.states.isNotEmpty) {
        showCupertinoModalBottomSheet(
            enableDrag: false,
            topRadius: const Radius.circular(16.0),
            barrierColor: Colors.black.withOpacity(0.6),
            backgroundColor: HexColors.white,
            context: context,
            builder: (sheetContext) => SelectionScreenWidget(
                title: Titles.status,
                value: _state ?? task?.state ?? '',
                items: _taskState!.states,
                onSelectTap: (state) => {
                      _state = state,
                      notifyListeners(),
                    }));
      }
    }
  }

  void showDateTimeSelectionSheet(BuildContext context) {
    TextStyle textStyle = const TextStyle(
      overflow: TextOverflow.ellipsis,
      fontFamily: 'PT Root UI',
    );

    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => DateTimeWheelPickerWidget(
            minDateTime: _minDateTime,
            maxDateTime: _maxDateTime,
            initialDateTime: _pickedDateTime,
            showDays: true,
            locale: locale,
            backgroundColor: HexColors.white,
            buttonColor: HexColors.primaryMain,
            buttonHighlightColor: HexColors.primaryDark,
            buttonTitle: Titles.apply,
            buttonTextStyle: textStyle.copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: HexColors.black),
            selecteTextStyle: textStyle.copyWith(
                fontSize: 14.0,
                color: HexColors.black,
                fontWeight: FontWeight.w400),
            unselectedTextStyle: textStyle.copyWith(
                fontSize: 12.0,
                color: HexColors.grey70,
                fontWeight: FontWeight.w400),
            onTap: (dateTime) => {
                  Navigator.pop(context),
                  _pickedDateTime = dateTime,
                  notifyListeners(),
                }));
  }

  void showSearchUserSheet(BuildContext context, int index) =>
      showCupertinoModalBottomSheet(
          enableDrag: false,
          topRadius: const Radius.circular(16.0),
          barrierColor: Colors.black.withOpacity(0.6),
          backgroundColor: HexColors.white,
          context: context,
          builder: (sheetContext) => SearchUserScreenWidget(
              title: index == 1
                  ? Titles.manager
                  : index == 2
                      ? Titles.coExecutor
                      : Titles.responsible,
              isRoot: true,
              onFocus: () => {},
              onPop: (user) => {
                    index == 1
                        ? _taskManager = user
                        : index == 2
                            ? _coExecutor = user
                            : _responsible = user,
                    notifyListeners(),
                    Navigator.pop(context)
                  }));

  void showSearchObjectSheet(BuildContext context) =>
      showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => SearchObjectScreenWidget(
            title: Titles.manager,
            isRoot: true,
            onFocus: () => {},
            onPop: (object) => {
                  _object = object,
                  notifyListeners(),
                  Navigator.pop(context),
                }),
      );

  void showSearchCompanySheet(BuildContext context) =>
      showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => SearchCompanyScreenWidget(
            title: Titles.company,
            isRoot: true,
            onFocus: () => {},
            onPop: (company) => {
                  _company = company,
                  notifyListeners(),
                  Navigator.pop(context),
                }),
      );
}
