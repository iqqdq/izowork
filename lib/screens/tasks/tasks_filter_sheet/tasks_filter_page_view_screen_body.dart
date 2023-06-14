import 'package:flutter/material.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/user.dart';
import 'package:izowork/models/tasks_filter_view_model.dart';
import 'package:izowork/screens/search_user/search_user_screen.dart';
import 'package:izowork/screens/tasks/tasks_filter_sheet/tasks_filter_screen.dart';
import 'package:izowork/views/dismiss_indicator_widget.dart';
import 'package:provider/provider.dart';

class TasksFilter {
  final User? user;
  final List<int> tags;
  final List<String> params;

  TasksFilter(this.user, this.tags, this.params);
}

class TasksFilterPageViewScreenBodyWidget extends StatefulWidget {
  final Function(TasksFilter?) onPop;

  const TasksFilterPageViewScreenBodyWidget({Key? key, required this.onPop})
      : super(key: key);

  @override
  _TasksFilterPageViewScreenBodyState createState() =>
      _TasksFilterPageViewScreenBodyState();
}

class _TasksFilterPageViewScreenBodyState
    extends State<TasksFilterPageViewScreenBodyWidget> {
  final PageController _pageController = PageController();
  late TasksFilterViewModel _tasksFilterViewModel;
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    _tasksFilterViewModel =
        Provider.of<TasksFilterViewModel>(context, listen: true);

    return Material(
        type: MaterialType.transparency,
        child: ListView(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              /// DISMISS INDICATOR
              const SizedBox(height: 6.0),
              const DismissIndicatorWidget(),
              AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _isSearching
                      ? MediaQuery.of(context).size.height * 0.9
                      : MediaQuery.of(context).padding.bottom == 0.0
                          ? 270.0
                          : 300.0,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      TasksFilterScreenWidget(
                          user: _tasksFilterViewModel.user,
                          options: _tasksFilterViewModel.options,
                          tags: _tasksFilterViewModel.tags,
                          onManagerTap: () => {
                                _pageController.animateToPage(1,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn),
                                setState(() => _isSearching = true)
                              },
                          onTagTap: (index) =>
                              _tasksFilterViewModel.sortByStage(index),
                          onApplyTap: () => {
                                _tasksFilterViewModel.apply((params) => {
                                      widget.onPop(TasksFilter(
                                          _tasksFilterViewModel.user,
                                          _tasksFilterViewModel.tags,
                                          params)),
                                      Navigator.pop(context)
                                    })
                              },
                          onResetTap: () => _tasksFilterViewModel.reset(() =>
                              {widget.onPop(null), Navigator.pop(context)})),
                      SearchUserScreenWidget(
                          title: Titles.responsible,
                          isRoot: false,
                          onFocus: () => setState,
                          onPop: (user) => {
                                _tasksFilterViewModel
                                    .setUser(user)
                                    .then((value) => {
                                          _pageController.animateToPage(0,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeIn),
                                          setState(() => _isSearching = false),
                                        })
                              })
                    ],
                  ))
            ]));
  }
}
