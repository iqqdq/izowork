import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/locale.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/toast.dart';
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
import 'package:izowork/views/date_time_wheel_picker_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TaskCreateViewModel with ChangeNotifier {
  // INIT
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

  List<Document> _files = [];

  TaskState? get taskState {
    return _taskState;
  }

  String? get state {
    return _state;
  }

  User? get responsible {
    return _responsible;
  }

  User? get taskManager {
    return _taskManager;
  }

  User? get coExecutor {
    return _coExecutor;
  }

  Object? get object {
    return _object;
  }

  Company? get company {
    return _company;
  }

  DateTime get minDateTime {
    return _minDateTime;
  }

  DateTime get maxDateTime {
    return _maxDateTime;
  }

  DateTime get pickedDateTime {
    return _pickedDateTime;
  }

  List<Document> get files {
    return _files;
  }

  TaskCreateViewModel(this.task) {
    if (task != null) {
      _pickedDateTime = DateTime.parse(task!.deadline);

      if (task!.files.isNotEmpty) {
        _files = task!.files;
      }

      notifyListeners();
    }

    getTaskStateList();
  }

  // MARK: -
  // MARK: - API CALL

  Future getTaskStateList() async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await TaskRepository().getTaskStates().then((response) => {
          if (response is TaskState) {_taskState = response}
        });
  }

  Future createNewTask(BuildContext context, String name, String? description,
      Function(Task) onCreate) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await TaskRepository()
        .createTask(TaskRequest(
            deadline: pickedDateTime.toUtc().toIso8601String(),
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
                {onCreate(response)}
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
                },
              notifyListeners()
            });
  }

  Future editTask(BuildContext context, String name, String? description,
      Function(Task) onCreate) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await TaskRepository()
        .updateTask(TaskRequest(
          id: task!.id,
          deadline: pickedDateTime.toUtc().toIso8601String(),
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
                {onCreate(response)}
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
                },
              notifyListeners()
            });
  }

  // MARK: -
  // MARK: - ACTIONS

  Future addFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc']);

    if (result != null) {
      // _files.add(Document(filename: filename, id: id, mimeType: mimeType, name: name, taskId: taskId));
      notifyListeners();
    }
  }

  void removeFile(int index) {
    _files.removeAt(index);
    notifyListeners();
  }

  // MARK: -
  // MARK: - PUSH

  void showSelectionScreenSheet(BuildContext context) {
    if (_taskState != null) {
      showCupertinoModalBottomSheet(
          topRadius: const Radius.circular(16.0),
          barrierColor: Colors.black.withOpacity(0.6),
          backgroundColor: HexColors.white,
          context: context,
          builder: (context) => SelectionScreenWidget(
              title: Titles.status,
              items: _taskState!.states,
              onSelectTap: (state) => {_state = state, notifyListeners()}));
    }
  }

  void showDateTimeSelectionSheet(BuildContext context) {
    TextStyle textStyle = const TextStyle(
        overflow: TextOverflow.ellipsis, fontFamily: 'PT Root UI');

    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        enableDrag: false,
        context: context,
        builder: (context) => DateTimeWheelPickerWidget(
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

  void showSearchUserScreenSheet(BuildContext context, int index) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => SearchUserScreenWidget(
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
  }

  void showSearchObjectScreenSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => SearchObjectScreenWidget(
            isRoot: true,
            onFocus: () => {},
            onPop: (object) =>
                {_object = object, notifyListeners(), Navigator.pop(context)}));
  }

  void showSearchCompanyScreenSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => SearchCompanyScreenWidget(
            isRoot: true,
            onFocus: () => {},
            onPop: (company) => {
                  _company = company,
                  notifyListeners(),
                  Navigator.pop(context)
                }));
  }
}
