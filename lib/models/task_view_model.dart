import 'package:flutter/material.dart';
import 'package:izowork/entities/response/task.dart';
import 'package:izowork/screens/task_create/task_create_screen.dart';

class TaskViewModel with ChangeNotifier {
  final Task task;

  TaskViewModel(this.task);

  // MARK: -
  // MARK: - ACTIONS

  // MARK: -
  // MARK: - PUSH

  void showTaskCreateScreenSheet(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TaskCreateScreenWidget(task: task)));
  }
}
