import 'package:flutter/material.dart';
import 'package:izowork/notifiers/domain.dart';
import 'package:izowork/screens/tasks/tasks_filter_sheet/tasks_filter_page_view_screen_body.dart';
import 'package:provider/provider.dart';

class TasksFilterPageViewScreenWidget extends StatelessWidget {
  final List<String> options;
  final TasksFilter? tasksFilter;
  final Function(TasksFilter?) onPop;

  const TasksFilterPageViewScreenWidget(
      {Key? key, required this.options, this.tasksFilter, required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => TasksFilterViewModel(options, tasksFilter),
        child: TasksFilterPageViewScreenBodyWidget(onPop: onPop));
  }
}
