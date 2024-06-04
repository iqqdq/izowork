import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/screens/search_company/search_company_screen.dart';
import 'package:izowork/screens/search_object/search_object_screen.dart';
import 'package:izowork/screens/search_user/search_user_screen.dart';
import 'package:izowork/screens/selection/selection_screen.dart';
import 'package:izowork/screens/task/task_screen.dart';
import 'package:izowork/views/views.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
      /// Editing task
      if (_taskCreateViewModel.task != null) {
        _nameTextEditingController.text = _taskCreateViewModel.task!.name;

        _descriptionTextEditingController.text =
            _taskCreateViewModel.task!.description;
      } else {
        /// Create task from chat
        _descriptionTextEditingController.text = widget.message ?? '';
      }
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
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: BackButtonWidget(
                onTap: () => {widget.onCreate(null), Navigator.pop(context)})),
        title: Text(
          _taskCreateViewModel.task == null ? Titles.newTask : Titles.editTask,
          style: TextStyle(
            overflow: TextOverflow.ellipsis,
            fontFamily: 'PT Root UI',
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
            color: HexColors.black,
          ),
        ),
      ),
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
                    onTap: () => _showSelectionSheet(),
                  ),

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
                    onTap: () => _showDateTimeSelectionSheet(),
                  ),

                  /// RESPONSIBLE SELECTION INPUT
                  SelectionInputWidget(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    isVertical: true,
                    title: Titles.responsible,
                    value: _taskCreateViewModel.responsible?.name ??
                        _taskCreateViewModel.task?.taskManager?.name ??
                        Titles.notSelected,
                    onTap: () => _showSearchUserSheet(0),
                  ),

                  /// TASK MANAGER SELECTION INPUT
                  SelectionInputWidget(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    isVertical: true,
                    title: Titles.taskManager,
                    value: _taskCreateViewModel.taskManager?.name ??
                        _taskCreateViewModel.task?.taskManager?.name ??
                        Titles.notSelected,
                    onTap: () => _showSearchUserSheet(1),
                  ),

                  /// CO-EXECUTOR SELECTION INPUT
                  SelectionInputWidget(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    isVertical: true,
                    title: Titles.coExecutor,
                    value: _taskCreateViewModel.coExecutor?.name ??
                        _taskCreateViewModel.task?.coExecutor?.name ??
                        Titles.notSelected,
                    onTap: () => _showSearchUserSheet(2),
                  ),

                  /// OBJECT SELECTION INPUT
                  SelectionInputWidget(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    isVertical: true,
                    title: Titles.object,
                    value: _taskCreateViewModel.object?.name ??
                        _taskCreateViewModel.task?.object?.name ??
                        Titles.notSelected,
                    onTap: () => _showSearchObjectSheet(),
                  ),

                  /// COMPANY SELECTION INPUT
                  SelectionInputWidget(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    isVertical: true,
                    title: Titles.company,
                    value: _taskCreateViewModel.company?.name ??
                        _taskCreateViewModel.task?.company?.name ??
                        Titles.notSelected,
                    onTap: () => _showSearchCompanySheet(),
                  ),

                  /// DESCRTIPTION INPUT
                  InputWidget(
                    textEditingController: _descriptionTextEditingController,
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
                              : _taskCreateViewModel.task!.files[index].id),
                          ignoring: _taskCreateViewModel.downloadIndex != -1,
                          child: FileListItemWidget(
                            fileName: _taskCreateViewModel.task == null
                                ? _taskCreateViewModel.files[index].path
                                    .substring(
                                        _taskCreateViewModel
                                                .files[index].path.length -
                                            10,
                                        _taskCreateViewModel
                                            .files[index].path.length)
                                : _taskCreateViewModel.task!.files[index].name,
                            isDownloading:
                                _taskCreateViewModel.downloadIndex == index,
                            onTap: () => _taskCreateViewModel.openFile(index),
                            onRemoveTap: () =>
                                _taskCreateViewModel.deleteTaskFile(index),
                          ),
                        );
                      }),

                  /// ADD FILE BUTTON
                  BorderButtonWidget(
                    title: Titles.addFile,
                    margin: const EdgeInsets.only(bottom: 30.0),
                    onTap: () => _taskCreateViewModel.addFile(),
                  ),
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
                      bottom: MediaQuery.of(context).padding.bottom == 0.0
                          ? 20.0
                          : MediaQuery.of(context).padding.bottom),
                  onTap: () => _createTask(),
                )),

            /// INDICATOR
            _taskCreateViewModel.loadingStatus == LoadingStatus.searching
                ? const LoadingIndicatorWidget()
                : Container()
          ]),
        ),
      ),
    );
  }

  void _showSelectionSheet() {
    if (_taskCreateViewModel.taskState == null) return;
    if (_taskCreateViewModel.taskState!.states.isEmpty) return;

    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => SelectionScreenWidget(
              title: Titles.status,
              value: _taskCreateViewModel.state ??
                  _taskCreateViewModel.task?.state ??
                  '',
              items: _taskCreateViewModel.taskState!.states,
              onSelectTap: (state) => _taskCreateViewModel.changeState(state),
            ));
  }

  void _showDateTimeSelectionSheet() {
    TextStyle textStyle = const TextStyle(
      overflow: TextOverflow.ellipsis,
      fontFamily: 'PT Root UI',
    );

    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => DateTimeWheelPickerWidget(
              minDateTime: _taskCreateViewModel.minDateTime,
              maxDateTime: _taskCreateViewModel.maxDateTime,
              initialDateTime: _taskCreateViewModel.pickedDateTime,
              showDays: true,
              locale: Platform.localeName,
              backgroundColor: HexColors.white,
              buttonColor: HexColors.primaryMain,
              buttonHighlightColor: HexColors.primaryDark,
              buttonTitle: Titles.apply,
              buttonTextStyle: textStyle.copyWith(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                  color: HexColors.black),
              selecteTextStyle: textStyle.copyWith(
                  fontSize: 14.0,
                  color: HexColors.black,
                  fontWeight: FontWeight.w400),
              unselectedTextStyle: textStyle.copyWith(
                  fontSize: 12.0,
                  color: HexColors.grey70,
                  fontWeight: FontWeight.w400),
              onTap: (dateTime) => {
                Navigator.pop(context),
                _taskCreateViewModel.changeDateTime(dateTime)
              },
            ));
  }

  void _showSearchUserSheet(int index) => showCupertinoModalBottomSheet(
      enableDrag: false,
      topRadius: const Radius.circular(16.0),
      barrierColor: Colors.black.withOpacity(0.6),
      backgroundColor: HexColors.white,
      context: context,
      builder: (sheetContext) => SearchUserScreenWidget(
            title: index == 1
                ? Titles.manager
                : index == 2
                    ? Titles.coExecutor
                    : Titles.responsible,
            isRoot: true,
            onFocus: () => {},
            onPop: (user) => {
              _taskCreateViewModel.changeUser(index, user),
              Navigator.pop(context)
            },
          ));

  void _showSearchObjectSheet() => showCupertinoModalBottomSheet(
      enableDrag: false,
      topRadius: const Radius.circular(16.0),
      barrierColor: Colors.black.withOpacity(0.6),
      backgroundColor: HexColors.white,
      context: context,
      builder: (sheetContext) => SearchObjectScreenWidget(
            title: Titles.manager,
            isRoot: true,
            onFocus: () => {},
            onPop: (object) => {
              _taskCreateViewModel.changeObject(object),
              Navigator.pop(context),
            },
          ));

  void _showSearchCompanySheet() => showCupertinoModalBottomSheet(
      enableDrag: false,
      topRadius: const Radius.circular(16.0),
      barrierColor: Colors.black.withOpacity(0.6),
      backgroundColor: HexColors.white,
      context: context,
      builder: (sheetContext) => SearchCompanyScreenWidget(
            title: Titles.company,
            isRoot: true,
            onFocus: () => {},
            onPop: (company) => {
              _taskCreateViewModel.changeCompany(company),
              Navigator.pop(context),
            },
          ));

  void _createTask() {
    _taskCreateViewModel.task == null
        ? _taskCreateViewModel.createNewTask(
            _nameTextEditingController.text,
            _descriptionTextEditingController.text,
            (task) => {
                  if (mounted)
                    {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TaskScreenWidget(id: task.id)))
                    }
                })
        : _taskCreateViewModel.editTask(
            _nameTextEditingController.text,
            _descriptionTextEditingController.text,
            (task) => {
                  if (mounted)
                    {
                      widget.onCreate(task),
                      Navigator.pop(context),
                    }
                });
  }
}
