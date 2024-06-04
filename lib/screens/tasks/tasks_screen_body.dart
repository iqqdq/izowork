import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/screens/task/task_screen.dart';
import 'package:izowork/screens/task_calendar/task_calendar_screen.dart';
import 'package:izowork/screens/task_create/task_create_screen.dart';
import 'package:izowork/screens/tasks/tasks_filter_sheet/tasks_filter_page_view_screen.dart';
import 'package:izowork/screens/tasks/tasks_filter_sheet/tasks_filter_page_view_screen_body.dart';
import 'package:izowork/screens/tasks/views/task_list_item_widget.dart';
import 'package:izowork/views/views.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class TasksScreenBodyWidget extends StatefulWidget {
  const TasksScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _TasksScreenBodyState createState() => _TasksScreenBodyState();
}

class _TasksScreenBodyState extends State<TasksScreenBodyWidget>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  Pagination _pagination = Pagination(offset: 0, size: 50);
  bool _isSearching = false;
  late TasksViewModel _tasksViewModel;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.offset += 1;
        _tasksViewModel.getTaskList(
            pagination: _pagination, search: _textEditingController.text);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _tasksViewModel = Provider.of<TasksViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
        backgroundColor: HexColors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            toolbarHeight: 74.0,
            titleSpacing: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Column(children: [
              const SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(children: [
                  Expanded(
                      child:

                          /// SEARCH INPUT
                          InputWidget(
                    textEditingController: _textEditingController,
                    focusNode: _focusNode,
                    margin: const EdgeInsets.only(right: 18.0),
                    isSearchInput: true,
                    placeholder: '${Titles.search}...',
                    onTap: () => setState,
                    onChange: (text) => {
                      setState(() => _isSearching = true),
                      EasyDebounce.debounce(
                          'task_debouncer', const Duration(milliseconds: 500),
                          () async {
                        _pagination = Pagination(offset: 0, size: 50);

                        _tasksViewModel
                            .getTaskList(
                              pagination: _pagination,
                              search: _textEditingController.text,
                            )
                            .then(
                              (value) => setState(
                                () => _isSearching = false,
                              ),
                            );
                      })
                    },
                    onClearTap: () => {
                      _tasksViewModel.resetFilter(),
                      _pagination = Pagination(offset: 0, size: 50),
                      _tasksViewModel.getTaskList(
                        pagination: _pagination,
                        search: _textEditingController.text,
                      )
                    },
                  )),

                  /// CALENDAR BUTTON
                  AssetImageButton(
                    imagePath: 'assets/ic_calendar.svg',
                    onTap: () => _showCalendarScreen(),
                  )
                ]),
              ),
              const SizedBox(height: 16.0),
              const SeparatorWidget()
            ])),
        floatingActionButton:
            FloatingButtonWidget(onTap: () => _showTaskCreateScreen()),
        body: SizedBox.expand(
            child: Stack(children: [
          /// TASKS LIST VIEW
          LiquidPullToRefresh(
            color: HexColors.primaryMain,
            backgroundColor: HexColors.white,
            springAnimationDurationInMilliseconds: 300,
            onRefresh: _onRefresh,
            child: ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                  bottom: 16.0 + 48.0,
                ),
                itemCount: _tasksViewModel.tasks.length,
                itemBuilder: (context, index) {
                  return TaskListItemWidget(
                    key: ValueKey(_tasksViewModel.tasks[index].id),
                    task: _tasksViewModel.tasks[index],
                    onTap: () => showTaskScreenWidget(index),
                  );
                }),
          ),

          /// FILTER BUTTON
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: FilterButtonWidget(
                  onTap: () => _showTasksFilterSheet(),
                ),
              ),
            ),
          ),

          /// EMPTY LIST TEXT
          _tasksViewModel.loadingStatus == LoadingStatus.completed &&
                  _tasksViewModel.tasks.isEmpty &&
                  !_isSearching
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      bottom: 100.0,
                    ),
                    child: Text(
                      Titles.noResult,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16.0,
                        color: HexColors.grey50,
                      ),
                    ),
                  ),
                )
              : Container(),

          /// INDICATOR
          _tasksViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future _onRefresh() async {
    _pagination = Pagination(offset: 0, size: 50);
    await _tasksViewModel.getTaskList(
      pagination: _pagination,
      search: _textEditingController.text,
    );
  }

  void _filter(TasksFilter tasksFilter) {
    _tasksViewModel.changeTaskFilter(tasksFilter);
    _pagination = Pagination(offset: 0, size: 50);
    _tasksViewModel.getTaskList(
      pagination: _pagination,
      search: _textEditingController.text,
    );
  }

  void _clear() {
    _tasksViewModel.resetFilter();
    _pagination = Pagination(offset: 0, size: 50);
    _tasksViewModel.getTaskList(
      pagination: _pagination,
      search: _textEditingController.text,
    );
  }

  // MARK: -
  // MARK: - PUSH

  void _showCalendarScreen() => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const TaskCalendarScreenWidget()));

  void _showTaskCreateScreen() => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskCreateScreenWidget(
            onCreate: (task) => {
                  if (task != null) _tasksViewModel.getTaskById(task.id),
                }),
      ));

  void _showTasksFilterSheet() {
    if (_tasksViewModel.taskState == null) return;
    if (_tasksViewModel.taskState!.states.isEmpty) return;

    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => TasksFilterPageViewScreenWidget(
              options: _tasksViewModel.taskState?.states ?? [],
              tasksFilter: _tasksViewModel.tasksFilter,
              onPop: (tasksFilter) => {
                if (tasksFilter == null) _clear() else _filter(tasksFilter),
              },
            ));
  }

  void showTaskScreenWidget(int index) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              TaskScreenWidget(id: _tasksViewModel.tasks[index].id)));
}
