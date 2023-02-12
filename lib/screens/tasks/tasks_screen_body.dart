import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/debouncer.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/models/tasks_view_model.dart';
import 'package:izowork/screens/tasks/views/task_list_item_widget.dart';
import 'package:izowork/views/filter_button_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/asset_image_button_widget.dart';
import 'package:izowork/views/floating_button_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/separator_widget.dart';
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
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

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

  // MARK: -
  // MARK: - FUNCTIONS

  Future _onRefresh() async {
    setState(() => _pagination = Pagination(offset: 0, size: 50));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _tasksViewModel = Provider.of<TasksViewModel>(context, listen: true);

    return Scaffold(
        backgroundColor: HexColors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            toolbarHeight: 74.0,
            titleSpacing: 0.0,
            elevation: 0.0,
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
                                      _debouncer.run(() {
                                        _pagination.offset = 0;

                                        _tasksViewModel
                                            .getTaskList(
                                                pagination: _pagination,
                                                search:
                                                    _textEditingController.text)
                                            .then((value) => setState(
                                                () => _isSearching = false));
                                      })
                                    },
                                onClearTap: () => {
                                      _tasksViewModel.resetFilter(),
                                      _pagination.offset = 0,
                                      _tasksViewModel.getTaskList(
                                          pagination: _pagination,
                                          search: _textEditingController.text)
                                    })),

                    /// CALENDAR BUTTON
                    AssetImageButton(
                        imagePath: 'assets/ic_calendar.png',
                        onTap: () =>
                            _tasksViewModel.showCalendarScreen(context))
                  ])),
              const SizedBox(height: 16.0),
              const SeparatorWidget()
            ])),
        floatingActionButton: FloatingButtonWidget(
            onTap: () => _tasksViewModel.showTaskCreateScreen(context)),
        body: SizedBox.expand(
            child: Stack(children: [
          /// TASKS LIST VIEW
          RefreshIndicator(
              onRefresh: _onRefresh,
              color: HexColors.primaryMain,
              backgroundColor: HexColors.white,
              child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 16.0, bottom: 16.0 + 48.0),
                  itemCount: _tasksViewModel.tasks.length,
                  itemBuilder: (context, index) {
                    return TaskListItemWidget(
                        task: _tasksViewModel.tasks[index],
                        onTap: () => _tasksViewModel.showTaskScreenWidget(
                            context, index));
                  })),

          /// FILTER BUTTON
          SafeArea(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: FilterButtonWidget(
                        onTap: () => _tasksViewModel.showTasksFilterSheet(
                            context,
                            () => {
                                  _pagination = Pagination(offset: 0, size: 50),
                                  _tasksViewModel.getTaskList(
                                      pagination: _pagination,
                                      search: _textEditingController.text)
                                }),
                        // onClearTap: () => {}
                      )))),

          /// EMPTY LIST TEXT
          _tasksViewModel.loadingStatus == LoadingStatus.completed &&
                  _tasksViewModel.tasks.isEmpty &&
                  !_isSearching
              ? Center(
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 116.0),
                      child: Text(Titles.noResult,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              color: HexColors.grey50))))
              : Container(),

          /// INDICATOR
          _tasksViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
