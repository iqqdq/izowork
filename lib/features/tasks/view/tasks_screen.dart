import 'package:flutter/material.dart';
import 'package:izowork/features/task_event/view_model/tasks_view_model.dart';
import 'package:izowork/features/tasks/view/tasks_screen_body.dart';
import 'package:provider/provider.dart';

class TasksScreenWidget extends StatelessWidget {
  const TasksScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => TasksViewModel(),
        child: const TasksScreenBodyWidget());
  }
}
