import 'package:flutter/material.dart';
import 'package:izowork/features/tasks/view_model/tasks_filter_view_model.dart';
import 'package:izowork/features/tasks/view/tasks_filter_sheet/tasks_filter_page_view_screen_body.dart';
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
