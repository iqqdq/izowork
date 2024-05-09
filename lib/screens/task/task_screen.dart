import 'package:flutter/material.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/screens/task/task_screen_body.dart';
import 'package:provider/provider.dart';

class TaskScreenWidget extends StatelessWidget {
  final Task task;

  const TaskScreenWidget({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => TaskViewModel(task),
        child: const TaskScreenBodyWidget());
  }
}
