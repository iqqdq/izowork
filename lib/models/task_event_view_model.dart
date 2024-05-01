import 'package:flutter/material.dart';
import 'package:izowork/entities/response/task.dart';
import 'package:izowork/screens/task/task_screen.dart';

class TaskEventViewModel with ChangeNotifier {
  final List<Task> tasks;

  TaskEventViewModel(this.tasks);

  // MARK: -
  // MARK: - PUSH

  void showTaskScreenWidget(
    BuildContext context,
    int index,
  ) =>
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TaskScreenWidget(task: tasks[index])));
}
