import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/models/task_view_model.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/button_widget.dart';
import 'package:izowork/views/file_list_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/subtitle_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:provider/provider.dart';

class TaskScreenBodyWidget extends StatefulWidget {
  const TaskScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _TaskScreenBodyState createState() => _TaskScreenBodyState();
}

class _TaskScreenBodyState extends State<TaskScreenBodyWidget> {
  late TaskViewModel _taskViewModel;

  @override
  Widget build(BuildContext context) {
    _taskViewModel = Provider.of<TaskViewModel>(
      context,
      listen: true,
    );

    final dateTime = DateTime.parse(_taskViewModel.task?.deadline ??
            _taskViewModel.selectedTask.deadline)
        .toUtc()
        .toLocal();

    final _day = dateTime.day.toString().length == 1
        ? '0${dateTime.day}'
        : '${dateTime.day}';
    final _month = dateTime.month.toString().length == 1
        ? '0${dateTime.month}'
        : '${dateTime.month}';
    final _year = '${dateTime.year}';

    final _description = _taskViewModel.task?.description ??
        _taskViewModel.selectedTask.description ??
        '';

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
            title: Text(
                _taskViewModel.task?.name ?? _taskViewModel.selectedTask.name,
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
                        /// STATUS
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.status,
                            isSmall: true),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            text: _taskViewModel.task?.state ??
                                _taskViewModel.selectedTask.state),

                        /// DEADLINE
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.deadline,
                            isSmall: true),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            text: '$_day.$_month.$_year'),

                        /// RESPONSIBLE
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.responsible,
                            isSmall: true),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            text: _taskViewModel.task?.responsible?.name ??
                                _taskViewModel.selectedTask.responsible?.name ??
                                '-'),

                        /// TASK MANAGER
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.taskManager,
                            isSmall: true),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            text: _taskViewModel.task?.taskManager?.name ??
                                _taskViewModel.selectedTask.taskManager?.name ??
                                '-'),

                        /// CO-EXECUTOR
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.coExecutor,
                            isSmall: true),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            text: _taskViewModel.task?.coExecutor?.name ??
                                _taskViewModel.selectedTask.coExecutor?.name ??
                                '-'),

                        /// OBJECT
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.object,
                            isSmall: true),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            text: _taskViewModel.task?.object?.name ??
                                _taskViewModel.selectedTask.object?.name ??
                                '-'),

                        /// COMPANY
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.company,
                            isSmall: true),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            text: _taskViewModel.task?.company?.name ??
                                _taskViewModel.selectedTask.company?.name ??
                                '-'),

                        /// DESCRTIPTION
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.description,
                            isSmall: true),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            text: _description.isEmpty ? '-' : _description),

                        /// FILE LIST
                        _taskViewModel.task == null ||
                                _taskViewModel.task!.files.isEmpty ||
                                _taskViewModel.selectedTask.files.isEmpty
                            ? Container()
                            : const TitleWidget(
                                padding: EdgeInsets.only(bottom: 10.0),
                                text: Titles.files,
                                isSmall: true),
                        ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(bottom: 16.0),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _taskViewModel.task?.files.length ??
                                _taskViewModel.selectedTask.files.length,
                            itemBuilder: (context, index) {
                              return FileListItemWidget(
                                  fileName:
                                      _taskViewModel.task?.files[index].name ??
                                          _taskViewModel
                                              .selectedTask.files[index].name,
                                  isDownloading:
                                      _taskViewModel.downloadIndex == index,
                                  onTap: () =>
                                      _taskViewModel.openFile(context, index));
                            }),
                      ]),

                  /// EDIT TASK BUTTON
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: ButtonWidget(
                          title: Titles.edit,
                          margin: EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              bottom:
                                  MediaQuery.of(context).padding.bottom == 0.0
                                      ? 20.0
                                      : MediaQuery.of(context).padding.bottom),
                          onTap: () =>
                              _taskViewModel.showTaskCreateSheet(context))),

                  /// INDICATOR
                  _taskViewModel.loadingStatus == LoadingStatus.searching
                      ? const LoadingIndicatorWidget()
                      : Container()
                ]))));
  }
}
