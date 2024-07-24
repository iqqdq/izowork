// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/features/tasks/view/tasks_filter_sheet/tasks_filter_page_view_screen_body.dart';

class TasksViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  TasksFilter? _tasksFilter;

  TasksFilter? get tasksFilter => _tasksFilter;

  TaskState? _taskState;

  TaskState? get taskState => _taskState;

  TasksViewModel() {
    getStateList();
  }

  // MARK: -
  // MARK: - API CALL

  Future getStateList() async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<TaskRepositoryInterface>()
        .getTaskStates()
        .then((response) => {
              if (response is TaskState) _taskState = response,
            })
        .whenComplete(() => getTaskList(
              pagination: Pagination(),
              search: '',
            ));
  }

  Future getTaskById(String id) async {
    loadingStatus = LoadingStatus.searching;

    await sl<TaskRepositoryInterface>()
        .getTask(id)
        .then((response) => {
              if (response is Task)
                {
                  _tasks.insert(0, response),
                  loadingStatus = LoadingStatus.completed,
                }
              else
                loadingStatus = LoadingStatus.error
            })
        .whenComplete(() => notifyListeners());
  }

  Future getTaskList({
    required Pagination pagination,
    required String search,
  }) async {
    if (pagination.offset == 0) {
      _tasks.clear();

      if (search.isNotEmpty) {
        loadingStatus = LoadingStatus.searching;
        notifyListeners();
      }
    }

    await sl<TaskRepositoryInterface>()
        .getTasks(
          pagination: pagination,
          search: search,
          params:
              _tasksFilter?.params ?? ["&sort_by=deadline", "&sort_order=desc"],
        )
        .then((response) => {
              if (response is List<Task>)
                {
                  if (_tasks.isEmpty)
                    response.forEach((task) => _tasks.add(task))
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
            })
        .whenComplete(() => notifyListeners());
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void changeTaskFilter(TasksFilter? tasksFilter) {
    _tasksFilter = tasksFilter;
    notifyListeners();
  }

  void resetFilter() => _tasksFilter = null;
}
