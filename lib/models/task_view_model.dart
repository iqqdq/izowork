import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/entities/task.dart';
import 'package:izowork/screens/task_create/task_create_screen.dart';

class TaskViewModel with ChangeNotifier {
  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  // MARK: -
  // MARK: - ACTIONS

  // MARK: -
  // MARK: - PUSH

  void showTaskCreateScreenSheet(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TaskCreateScreenWidget(task: Task())));
  }
}
