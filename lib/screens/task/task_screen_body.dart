import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/notifiers/domain.dart';
import 'package:izowork/screens/task_create/task_create_screen.dart';
import 'package:izowork/views/views.dart';
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

    final dateTime = _taskViewModel.task?.deadline == null
        ? null
        : DateTime.parse(_taskViewModel.task!.deadline).toUtc().toLocal();

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
          _taskViewModel.task?.name ?? '',
          style: TextStyle(
            overflow: TextOverflow.ellipsis,
            fontFamily: 'PT Root UI',
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
            color: HexColors.black,
          ),
        ),
      ),
      body: _taskViewModel.task == null
          ? const LoadingIndicatorWidget()
          : Material(
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
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          text: _taskViewModel.task?.state ?? '-',
                        ),

                        /// DEADLINE
                        const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.deadline,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          text: dateTime == null
                              ? '-'
                              : DateTimeFormatter().formatDateTimeToString(
                                  dateTime: dateTime,
                                  showTime: false,
                                  showMonthName: false,
                                ),
                        ),

                        /// RESPONSIBLE
                        const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.responsible,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          text: _taskViewModel.task?.responsible?.name ?? '-',
                        ),

                        /// TASK MANAGER
                        const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.taskManager,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          text: _taskViewModel.task?.taskManager?.name ?? '-',
                        ),

                        /// CO-EXECUTOR
                        const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.coExecutor,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          text: _taskViewModel.task?.coExecutor?.name ?? '-',
                        ),

                        /// OBJECT
                        const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.object,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          text: _taskViewModel.task?.object?.name ?? '-',
                        ),

                        /// COMPANY
                        const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.company,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          text: _taskViewModel.task?.company?.name ?? '-',
                        ),

                        /// DESCRTIPTION
                        const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.description,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            text: _taskViewModel.task?.description ?? '-'),

                        /// FILE LIST
                        _taskViewModel.task == null
                            ? Container()
                            : _taskViewModel.task!.files.isEmpty
                                ? Container()
                                : const TitleWidget(
                                    padding: EdgeInsets.only(bottom: 10.0),
                                    text: Titles.files,
                                    isSmall: true,
                                  ),
                        ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(bottom: 16.0),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _taskViewModel.task?.files.length ?? 0,
                            itemBuilder: (context, index) {
                              return FileListItemWidget(
                                key: ValueKey(
                                    _taskViewModel.task?.files[index].id ?? ''),
                                fileName:
                                    _taskViewModel.task?.files[index].name ??
                                        '',
                                isDownloading:
                                    _taskViewModel.downloadIndex == index,
                                onTap: () => _openFile(index),
                              );
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
                          bottom: MediaQuery.of(context).padding.bottom == 0.0
                              ? 20.0
                              : MediaQuery.of(context).padding.bottom),
                      onTap: () => _showTaskCreateScreen(),
                    ),
                  ),

                  /// INDICATOR
                  _taskViewModel.loadingStatus == LoadingStatus.searching
                      ? const LoadingIndicatorWidget()
                      : Container()
                ]),
              ),
            ),
    );
  }

  void _openFile(int index) {
    _taskViewModel.openFile(
      index,
      () => Toast().showTopToast(context, Titles.unsupportedFileFormat),
    );
  }

  void _showTaskCreateScreen() {
    if (_taskViewModel.task == null) return;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TaskCreateScreenWidget(
                  task: _taskViewModel.task,
                  onCreate: (task) => _taskViewModel.getTaskById(),
                )));
  }
}
