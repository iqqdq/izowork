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
  final ScrollController _scrollController = ScrollController();
  late TaskEventViewModel _taskEventViewModel;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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

    return Material(
        type: MaterialType.transparency,
        child: Container(
            height: MediaQuery.of(context).size.height,
            color: HexColors.white,
            child: Scrollbar(
                child: NotificationListener<ScrollEndNotification>(
                    onNotification: (notification) {
                      if (_scrollController.position.pixels == 0.0 &&
                          MediaQuery.of(context).viewInsets.bottom == 0.0) {
                        Navigator.pop(context);
                      }

                      // Return true to cancel the notification bubbling. Return false (or null) to
                      // allow the notification to continue to be dispatched to further ancestors.
                      return true;
                    },
                    child: ListView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.only(
                            top: 8.0,
                            left: 16.0,
                            right: 16.0,
                            bottom: (MediaQuery.of(context).padding.bottom ==
                                        0.0
                                    ? 20.0
                                    : MediaQuery.of(context).padding.bottom) +
                                MediaQuery.of(context).viewInsets.bottom),
                        children: [
                          /// DISMISS INDICATOR
                          const SizedBox(height: 6.0),
                          const DismissIndicatorWidget(),

                          /// TITLE
                          Row(
                            children: [
                              Expanded(
                                  child: Material(
                                      type: MaterialType.transparency,
                                      child: Text(
                                          'Сделки на $_day ${_month.substring(0, 3)} $_year',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                              color: HexColors.black,
                                              fontFamily: 'PT Root UI'))))
                            ],
                          ),

                          /// TASK LIST VIEW
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(top: 16.0),
                              itemCount: _taskEventViewModel.tasks.length,
                              itemBuilder: (context, index) {
                                return TaskListItemWidget(
                                    task: _taskEventViewModel.tasks[index],
                                    onTap: () => _taskEventViewModel
                                        .showTaskScreenWidget(context, index));
                              }),
                        ])))));
  }
}
