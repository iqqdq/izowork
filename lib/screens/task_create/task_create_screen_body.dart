import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/task.dart';
import 'package:izowork/models/task_create_view_model.dart';
import 'package:izowork/models/search_view_model.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/button_widget_widget.dart';
import 'package:izowork/views/file_list_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/views/selection_input_widget.dart';
import 'package:provider/provider.dart';

class TaskCreateScreenBodyWidget extends StatefulWidget {
  final Task? task;

  const TaskCreateScreenBodyWidget({Key? key, this.task}) : super(key: key);

  @override
  _TaskCreateScreenBodyState createState() => _TaskCreateScreenBodyState();
}

class _TaskCreateScreenBodyState extends State<TaskCreateScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late TaskCreateViewModel _taskCreateViewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _taskCreateViewModel =
        Provider.of<TaskCreateViewModel>(context, listen: true);

    final _day = _taskCreateViewModel.pickedDateTime.day.toString().length == 1
        ? '0${_taskCreateViewModel.pickedDateTime.day}'
        : '${_taskCreateViewModel.pickedDateTime.day}';
    final _month =
        _taskCreateViewModel.pickedDateTime.month.toString().length == 1
            ? '0${_taskCreateViewModel.pickedDateTime.month}'
            : '${_taskCreateViewModel.pickedDateTime.month}';
    final _year = '${_taskCreateViewModel.pickedDateTime.year}';

    return Scaffold(
        backgroundColor: HexColors.white,
        appBar: AppBar(
            centerTitle: true,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            leading: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: BackButtonWidget(onTap: () => Navigator.pop(context))),
            title: Text(widget.task == null ? Titles.newTask : Titles.editTask,
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
                        /// STATUS SELECTION INPUT
                        SelectionInputWidget(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            isVertical: true,
                            title: Titles.status,
                            value: Titles.notSelected,
                            onTap: () => _taskCreateViewModel
                                .showSelectionScreenSheet(context)),

                        /// DEADLINE SELECTION INPUT
                        SelectionInputWidget(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            isDate: true,
                            title: Titles.deadline,
                            value: '$_day.$_month.$_year',
                            onTap: () => _taskCreateViewModel
                                .showDateTimeSelectionSheet(context)),

                        /// RESPONSIBLE SELECTION INPUT
                        SelectionInputWidget(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            isVertical: true,
                            title: Titles.responsible,
                            value: Titles.notSelected,
                            onTap: () =>
                                _taskCreateViewModel.showSearchScreenSheet(
                                    context, SearchType.responsible)),

                        /// TASK MANAGER SELECTION INPUT
                        SelectionInputWidget(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            isVertical: true,
                            title: Titles.taskManager,
                            value: Titles.notSelected,
                            onTap: () =>
                                _taskCreateViewModel.showSearchScreenSheet(
                                    context, SearchType.responsible)),

                        /// CO-EXECUTOR SELECTION INPUT
                        SelectionInputWidget(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            isVertical: true,
                            title: Titles.coExecutor,
                            value: Titles.notSelected,
                            onTap: () =>
                                _taskCreateViewModel.showSearchScreenSheet(
                                    context, SearchType.responsible)),

                        /// OBJECT SELECTION INPUT
                        SelectionInputWidget(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            isVertical: true,
                            title: Titles.object,
                            value: Titles.notSelected,
                            onTap: () =>
                                _taskCreateViewModel.showSearchScreenSheet(
                                    context, SearchType.object)),

                        /// COMPANY SELECTION INPUT
                        SelectionInputWidget(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            isVertical: true,
                            title: Titles.company,
                            value: Titles.notSelected,
                            onTap: () =>
                                _taskCreateViewModel.showSearchScreenSheet(
                                    context, SearchType.company)),

                        /// DESCRTIPTION INPUT
                        InputWidget(
                          textEditingController: _textEditingController,
                          focusNode: _focusNode,
                          height: 168.0,
                          maxLines: 10,
                          margin: EdgeInsets.zero,
                          placeholder: '${Titles.description}...',
                          onTap: () => setState,
                          onChange: (text) => {
                            // TODO DESCRTIPTION
                          },
                        ),
                        const SizedBox(height: 10.0),

                        /// FILE LIST
                        ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return const FileListItemWidget(
                                  fileName: 'file.pdf');
                            }),

                        /// ADD FILE BUTTON
                        BorderButtonWidget(
                            title: Titles.addFile,
                            margin: const EdgeInsets.only(bottom: 30.0),
                            onTap: () => _taskCreateViewModel.addFile()),
                      ]),

                  /// ADD TASK BUTTON
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: ButtonWidget(
                          isDisabled: true,
                          title: widget.task == null
                              ? Titles.createTask
                              : Titles.save,
                          margin: EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              bottom:
                                  MediaQuery.of(context).padding.bottom == 0.0
                                      ? 20.0
                                      : MediaQuery.of(context).padding.bottom),
                          onTap: () => {}))
                ]))));
  }
}
