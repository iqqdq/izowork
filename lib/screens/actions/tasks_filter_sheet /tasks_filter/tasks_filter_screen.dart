import 'package:flutter/material.dart';
import 'package:izowork/models/tasks_filter_view_model.dart';
import 'package:izowork/screens/actions/tasks_filter_sheet%20/tasks_filter/tasks_filter_screen_body.dart';
import 'package:provider/provider.dart';

class TasksFilterScreenWidget extends StatelessWidget {
  final VoidCallback onResponsibleTap;
  final VoidCallback onApplyTap;
  final VoidCallback onResetTap;

  const TasksFilterScreenWidget(
      {Key? key,
      required this.onResponsibleTap,
      required this.onApplyTap,
      required this.onResetTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => TasksFilterViewModel(),
        child: TasksFilterScreenBodyWidget(
            onResponsibleTap: onResponsibleTap,
            onApplyTap: onApplyTap,
            onResetTap: onResetTap));
  }
}
