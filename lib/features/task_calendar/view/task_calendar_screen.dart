import 'package:flutter/material.dart';
import 'package:izowork/features/task_calendar/view_model/task_calendar_view_model.dart';
import 'package:izowork/features/task_calendar/view/task_calendar_screen_body.dart';
import 'package:provider/provider.dart';

class TaskCalendarScreenWidget extends StatelessWidget {
  const TaskCalendarScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskCalendarViewModel(),
      child: const TaskCalendarScreenBodyWidget(),
    );
  }
}
