import 'package:flutter/material.dart';
import 'package:izowork/features/task_create/view_model/task_create_view_model.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/features/task_create/view/task_create_screen_body.dart';
import 'package:provider/provider.dart';

class TaskCreateScreenWidget extends StatelessWidget {
  final Task? task;
  final String? message;
  final Function(Task?) onCreate;

  const TaskCreateScreenWidget(
      {Key? key, this.task, this.message, required this.onCreate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => TaskCreateViewModel(task),
        child: TaskCreateScreenBodyWidget(
          message: message,
          onCreate: onCreate,
        ));
  }
}
