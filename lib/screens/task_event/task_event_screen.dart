import 'package:flutter/material.dart';
import 'package:izowork/models/task_event_view_model.dart';
import 'package:izowork/screens/task_event/task_event_screen_body_widget.dart';
import 'package:provider/provider.dart';

class TaskEventScreenWidget extends StatelessWidget {
  final DateTime dateTime;

  const TaskEventScreenWidget({Key? key, required this.dateTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => TaskEventViewModel(),
        child: TaskEventScreenBodyWidget(dateTime: dateTime));
  }
}