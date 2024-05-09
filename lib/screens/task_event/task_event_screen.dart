import 'package:flutter/material.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/screens/task_event/task_event_screen_body_widget.dart';
import 'package:provider/provider.dart';

class TaskEventScreenWidget extends StatelessWidget {
  final DateTime dateTime;
  final List<Task> tasks;

  const TaskEventScreenWidget(
      {Key? key, required this.dateTime, required this.tasks})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => TaskEventViewModel(tasks),
        child: TaskEventScreenBodyWidget(dateTime: dateTime));
  }
}
