// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/response/task.dart';
import 'package:izowork/entities/response/task_state.dart';
import 'package:izowork/repositories/task_repository.dart';
import 'package:izowork/screens/task/task_screen.dart';
import 'package:izowork/screens/task_create/task_create_screen.dart';
import 'package:izowork/screens/task_calendar/task_calendar_screen.dart';
import 'package:izowork/screens/tasks/tasks_filter_sheet/tasks_filter_page_view_screen.dart';
import 'package:izowork/screens/tasks/tasks_filter_sheet/tasks_filter_page_view_screen_body.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TasksViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<Task> _tasks = [];

  TasksFilter? _tasksFilter;

  TaskState? _taskState;

  List<Task> get tasks {
    return _tasks;
  }

  TaskState? get taskState {
    return _taskState;
  }

  TasksViewModel() {
    getStateList();
  }

  // MARK: -
  // MARK: - API CALL

  Future getStateList() async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await TaskRepository()
        .getTaskStates()
        .then((response) => {
              if (response is TaskState) {_taskState = response}
            })
        .then((value) => getTaskList(
            pagination: Pagination(offset: 0, size: 50), search: ''));
  }

  Future getTaskById(String id) async {
    loadingStatus = LoadingStatus.searching;

    await TaskRepository().getTask(id).then((response) => {
          if (response is Task)
            {
              _tasks.insert(0, response),
              loadingStatus = LoadingStatus.completed,
            }
          else
            {loadingStatus = LoadingStatus.error},
          notifyListeners()
        });
  }

  Future getTaskList(
      {required Pagination pagination, required String search}) async {
    if (pagination.offset == 0) {
      loadingStatus = LoadingStatus.searching;
      _tasks.clear();

      Future.delayed(Duration.zero, () async {
        notifyListeners();
      });
    }

    await TaskRepository()
        .getTasks(
            pagination: pagination,
            search: search,
            params: _tasksFilter?.params ??
                ["&sort_by=deadline", "&sort_order=desc"])
        .then((response) => {
              if (response is List<Task>)
                {
                  if (_tasks.isEmpty)
                    {
                      response.forEach((task) {
                        _tasks.add(task);
                      })
                    }
                  else
                    {
                      response.forEach((newTask) {
                        bool found = false;

                        _tasks.forEach((task) {
                          if (newTask.id == task.id) {
                            found = true;
                          }
                        });

                        if (!found) {
                          _tasks.add(newTask);
                        }
                      })
                    },
                  loadingStatus = LoadingStatus.completed
                }
              else
                loadingStatus = LoadingStatus.error,
              notifyListeners()
            });
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void resetFilter() {
    _tasksFilter = null;
  }

  // MARK: -
  // MARK: - PUSH

  void showCalendarScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const TaskCalendarScreenWidget()));
  }

  void showTaskCreateScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TaskCreateScreenWidget(
                onCreate: (task) => {
                      if (task != null) {getTaskById(task.id)}
                    })));
  }

  void showTasksFilterSheet(BuildContext context, Function() onFilter) {
    if (_taskState != null) {
      if (_taskState!.states.isNotEmpty) {
        showCupertinoModalBottomSheet(
            enableDrag: false,
            topRadius: const Radius.circular(16.0),
            barrierColor: Colors.black.withOpacity(0.6),
            backgroundColor: HexColors.white,
            context: context,
            builder: (sheetContext) => TasksFilterPageViewScreenWidget(
                options: _taskState!.states,
                tasksFilter: _tasksFilter,
                onPop: (tasksFilter) => {
                      if (tasksFilter == null)
                        {
                          // CLEAR
                          resetFilter(),
                          onFilter()
                        }
                      else
                        {
                          // FILTER
                          _tasksFilter = tasksFilter,
                          onFilter()
                        }
                    }));
      }
    }
  }

  void showTaskScreenWidget(BuildContext context, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TaskScreenWidget(task: _tasks[index])));
  }
}
