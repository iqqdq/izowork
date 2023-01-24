import 'package:flutter/material.dart';
import 'package:izowork/models/tasks_filter_search_view_model.dart';
import 'package:izowork/screens/actions/tasks_filter_sheet%20/tasks_filter_search/tasks_filter_search_screen_body.dart';
import 'package:provider/provider.dart';

class TasksFilterSearchScreenWidget extends StatelessWidget {
  final VoidCallback onPop;

  const TasksFilterSearchScreenWidget({Key? key, required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => TasksFilterSearchViewModel(),
        child: TasksFilterSearchBodyScreenWidget(onPop: onPop));
  }
}
