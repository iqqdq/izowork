import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/date_time_string_formatter.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/task.dart';
import 'package:izowork/models/task_create_view_model.dart';
import 'package:izowork/screens/task/task_screen.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/button_widget.dart';
import 'package:izowork/views/file_list_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/selection_input_widget.dart';
import 'package:provider/provider.dart';

class TaskCreateScreenBodyWidget extends StatefulWidget {
  final String? message;
  final Function(Task?) onCreate;

  const TaskCreateScreenBodyWidget(
      {Key? key, this.message, required this.onCreate})
      : super(key: key);

  @override
  _TaskCreateScreenBodyState createState() => _TaskCreateScreenBodyState();
}

class _TaskCreateScreenBodyState extends State<TaskCreateScreenBodyWidget> {
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final TextEditingController _descriptionTextEditingController =
      TextEditingController();
  final FocusNode _descriptionFocusNode = FocusNode();
  late TaskCreateViewModel _taskCreateViewModel;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// EDIT TASK
      if (_taskCreateViewModel.task != null) {
        _nameTextEditingController.text = _taskCreateViewModel.task!.name;

        _descriptionTextEditingController.text =
            _taskCreateViewModel.task!.description;
      }

      /// CREATE TASK FROM CHAT STATE
      _descriptionTextEditingController.text = widget.message ?? '';
    });
  }

  @override
  void dispose() {
    _nameTextEditingController.dispose();
    _nameFocusNode.dispose();
    _descriptionTextEditingController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _taskCreateViewModel = Provider.of<TaskCreateViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
        backgroundColor: HexColors.white,
        appBar: AppBar(
            centerTitle: true,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            leading: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: BackButtonWidget(
                    onTap: () =>
                        {widget.onCreate(null), Navigator.pop(context)})),
            title: Text(
                _taskCreateViewModel.task == null
                    ? Titles.newTask
                    : Titles.editTask,
                style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontFamily: 'PT Root UI',
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: HexColors.black))),
        body: Material(
            type: MaterialType.transparency,
            child: Container(
                color: HexColors.white,
                child: Stack(children: [
                  ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                          top: 14.0,
                          left: 16.0,
                          right: 16.0,
                          bottom: MediaQuery.of(context).padding.bottom == 0.0
                              ? 20.0 + 54.0
                              : MediaQuery.of(context).padding.bottom + 54.0),
                      children: [
                        /// NAME INPUT
                        InputWidget(
                          textEditingController: _nameTextEditingController,
                          focusNode: _nameFocusNode,
                          margin: EdgeInsets.zero,
                          height: 58.0,
                          placeholder: Titles.taskName,
                          onTap: () => setState,
                          onChange: (text) => setState,
                        ),
                        const SizedBox(height: 10.0),

                        /// STATUS SELECTION INPUT
                        SelectionInputWidget(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            isVertical: true,
                            title: Titles.status,
                            value: _taskCreateViewModel.state ??
                                _taskCreateViewModel.task?.state ??
                                Titles.notSelected,
                            onTap: () => _taskCreateViewModel
                                .showSelectionSheet(context)),

                        /// DEADLINE SELECTION INPUT
                        SelectionInputWidget(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            isDate: true,
                            title: Titles.deadline,
                            value: DateTimeFormatter().formatDateTimeToString(
                              dateTime: _taskCreateViewModel.pickedDateTime,
                              showTime: false,
                              showMonthName: false,
                            ),
                            onTap: () => _taskCreateViewModel
                                .showDateTimeSelectionSheet(context)),

                        /// RESPONSIBLE SELECTION INPUT
                        SelectionInputWidget(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            isVertical: true,
                            title: Titles.responsible,
                            value: _taskCreateViewModel.responsible?.name ??
                                _taskCreateViewModel.task?.taskManager?.name ??
                                Titles.notSelected,
                            onTap: () => _taskCreateViewModel
                                .showSearchUserSheet(context, 0)),

                        /// TASK MANAGER SELECTION INPUT
                        SelectionInputWidget(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            isVertical: true,
                            title: Titles.taskManager,
                            value: _taskCreateViewModel.taskManager?.name ??
                                _taskCreateViewModel.task?.taskManager?.name ??
                                Titles.notSelected,
                            onTap: () => _taskCreateViewModel
                                .showSearchUserSheet(context, 1)),

                        /// CO-EXECUTOR SELECTION INPUT
                        SelectionInputWidget(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            isVertical: true,
                            title: Titles.coExecutor,
                            value: _taskCreateViewModel.coExecutor?.name ??
                                _taskCreateViewModel.task?.coExecutor?.name ??
                                Titles.notSelected,
                            onTap: () => _taskCreateViewModel
                                .showSearchUserSheet(context, 2)),

                        /// OBJECT SELECTION INPUT
                        SelectionInputWidget(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            isVertical: true,
                            title: Titles.object,
                            value: _taskCreateViewModel.object?.name ??
                                _taskCreateViewModel.task?.object?.name ??
                                Titles.notSelected,
                            onTap: () => _taskCreateViewModel
                                .showSearchObjectSheet(context)),

                        /// COMPANY SELECTION INPUT
                        SelectionInputWidget(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            isVertical: true,
                            title: Titles.company,
                            value: _taskCreateViewModel.company?.name ??
                                _taskCreateViewModel.task?.company?.name ??
                                Titles.notSelected,
                            onTap: () => _taskCreateViewModel
                                .showSearchCompanySheet(context)),

                        /// DESCRTIPTION INPUT
                        InputWidget(
                          textEditingController:
                              _descriptionTextEditingController,
                          focusNode: _descriptionFocusNode,
                          height: 168.0,
                          maxLines: 10,
                          margin: EdgeInsets.zero,
                          placeholder: '${Titles.description}...',
                          onTap: () => setState,
                          onChange: (text) => setState,
                        ),
                        const SizedBox(height: 10.0),

                        /// FILE LIST
                        ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _taskCreateViewModel.task == null
                                ? _taskCreateViewModel.files.length
                                : _taskCreateViewModel.task!.files.length,
                            itemBuilder: (context, index) {
                              return IgnorePointer(
                                  key: ValueKey(_taskCreateViewModel.task == null
                                      ? _taskCreateViewModel.files[index].path
                                      : _taskCreateViewModel
                                          .task!.files[index].id),
                                  ignoring:
                                      _taskCreateViewModel.downloadIndex != -1,
                                  child: FileListItemWidget(
                                      fileName: _taskCreateViewModel.task == null
                                          ? _taskCreateViewModel.files[index].path
                                              .substring(
                                                  _taskCreateViewModel
                                                          .files[index]
                                                          .path
                                                          .length -
                                                      10,
                                                  _taskCreateViewModel
                                                      .files[index].path.length)
                                          : _taskCreateViewModel
                                              .task!.files[index].name,
                                      isDownloading:
                                          _taskCreateViewModel.downloadIndex ==
                                              index,
                                      onTap: () =>
                                          _taskCreateViewModel.openFile(context, index),
                                      onRemoveTap: () => _taskCreateViewModel.deleteTaskFile(context, index)));
                            }),

                        /// ADD FILE BUTTON
                        BorderButtonWidget(
                            title: Titles.addFile,
                            margin: const EdgeInsets.only(bottom: 30.0),
                            onTap: () => _taskCreateViewModel.addFile(context)),
                      ]),

                  /// ADD TASK BUTTON
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: ButtonWidget(
                          isDisabled: _taskCreateViewModel.loadingStatus ==
                                      LoadingStatus.searching ||
                                  _taskCreateViewModel.task == null
                              ? _nameTextEditingController.text.isEmpty ||
                                  _taskCreateViewModel.state == null
                              : _nameTextEditingController.text.isEmpty,
                          title: _taskCreateViewModel.task == null
                              ? Titles.createTask
                              : Titles.save,
                          margin: EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              bottom:
                                  MediaQuery.of(context).padding.bottom == 0.0
                                      ? 20.0
                                      : MediaQuery.of(context).padding.bottom),
                          onTap: () => _taskCreateViewModel.task == null
                              ? _taskCreateViewModel.createNewTask(
                                  context,
                                  _nameTextEditingController.text,
                                  _descriptionTextEditingController.text,
                                  (task) => {
                                        if (mounted)
                                          {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        TaskScreenWidget(
                                                            task: task)))
                                          }
                                      })
                              : _taskCreateViewModel.editTask(
                                  context,
                                  _nameTextEditingController.text,
                                  _descriptionTextEditingController.text,
                                  (task) => {
                                        if (mounted)
                                          {
                                            widget.onCreate(task),
                                            Navigator.pop(context)
                                          }
                                      }))),

                  /// INDICATOR
                  _taskCreateViewModel.loadingStatus == LoadingStatus.searching
                      ? const LoadingIndicatorWidget()
                      : Container()
                ]))));
  }
}
