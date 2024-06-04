// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';

class TaskCalendarViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  // MARK: -
  // MARK: - API CALL

  Future getTaskList(DateTime dateTime) async {
    loadingStatus = LoadingStatus.searching;
    _tasks.clear();

    notifyListeners();

    await TaskRepository()
        .getYearTasks(params: [
          "deadline=gte:${dateTime.year}-01-01T00:00:00Z&deadline=lte:${dateTime.year}-12-31T00:00:00Z"
        ])
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
                  loadingStatus = LoadingStatus.completed,
                }
              else
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => notifyListeners());
  }

  // MARK: -
  // MARK: - FUNCTIONS

  int getTaskCount(DateTime dateTime) {
    int count = 0;

    _tasks.forEach((element) {
      if (dateTime.year == DateTime.parse(element.deadline).year &&
          dateTime.month == DateTime.parse(element.deadline).month &&
          dateTime.day == DateTime.parse(element.deadline).day) {
        count++;
      }
    });

    return count;
  }
}
