import 'package:flutter/material.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/screens/tasks/tasks_screen_body.dart';
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
