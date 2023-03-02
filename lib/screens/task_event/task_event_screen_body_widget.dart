import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/locale.dart';
import 'package:izowork/models/task_event_view_model.dart';
import 'package:izowork/screens/tasks/views/task_list_item_widget.dart';
import 'package:izowork/views/dismiss_indicator_widget.dart';
import 'package:provider/provider.dart';

class TaskEventScreenBodyWidget extends StatefulWidget {
  final DateTime dateTime;

  const TaskEventScreenBodyWidget({Key? key, required this.dateTime})
      : super(key: key);

  @override
  _TaskEventScreenBodyState createState() => _TaskEventScreenBodyState();
}

class _TaskEventScreenBodyState extends State<TaskEventScreenBodyWidget> {
  late TaskEventViewModel _taskEventViewModel;

  @override
  Widget build(BuildContext context) {
    _taskEventViewModel =
        Provider.of<TaskEventViewModel>(context, listen: true);

    final _day = DateTime.now().day.toString().length == 1
        ? '0${DateTime.now().day}'
        : '${DateTime.now().day}';
    final _month =
        DateFormat.MMMM(locale).format(widget.dateTime).toLowerCase();
    final _year = '${DateTime.now().year}';

    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Stack(children: [
          /// TASK LIST VIEW
          SizedBox.expand(
              child: Scrollbar(
                  child: ListView.builder(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 70.0, bottom: 16.0),
                      itemCount: _taskEventViewModel.tasks.length,
                      itemBuilder: (context, index) {
                        return TaskListItemWidget(
                            task: _taskEventViewModel.tasks[index],
                            onTap: () => _taskEventViewModel
                                .showTaskScreenWidget(context, index));
                      }))),

          Container(
            width: double.infinity,
            height: 70.0,
            color: HexColors.white,
            child: Padding(
                padding: const EdgeInsets.only(
                    top: 24.0, bottom: 16.0, left: 16.0, right: 16.0),
                child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                        'Сделки на $_day ${_month.substring(0, 3)} $_year',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: HexColors.black,
                            fontFamily: 'PT Root UI')))),
          ),

          Column(children: const [
            /// DISMISS INDICATOR
            SizedBox(height: 6.0),
            DismissIndicatorWidget(),
          ])
        ]));
  }
}
