import 'package:flutter/material.dart';
import 'package:izowork/models/event_task_view_model.dart';
import 'package:izowork/screens/task_calendar/event_task/event_task_screen_body_widget.dart';
import 'package:provider/provider.dart';

class EventTaskScreenWidget extends StatelessWidget {
  final DateTime dateTime;

  const EventTaskScreenWidget({Key? key, required this.dateTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => EventTaskViewModel(),
        child: EventTaskScreenBodyWidget(dateTime: dateTime));
  }
}
