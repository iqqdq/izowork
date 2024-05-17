import 'package:flutter/material.dart';
import 'package:izowork/notifiers/domain.dart';
import 'package:izowork/screens/task/task_screen_body.dart';
import 'package:provider/provider.dart';

class TaskScreenWidget extends StatelessWidget {
  final String id;

  const TaskScreenWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => TaskViewModel(id),
        child: const TaskScreenBodyWidget());
  }
}
