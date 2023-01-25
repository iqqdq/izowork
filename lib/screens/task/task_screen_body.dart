import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/task.dart';
import 'package:izowork/models/task_create_view_model.dart';
import 'package:izowork/models/search_view_model.dart';
import 'package:izowork/models/task_view_model.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/button_widget_widget.dart';
import 'package:izowork/views/file_list_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/views/selection_input_widget.dart';
import 'package:izowork/views/subtitle_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:provider/provider.dart';

class TaskScreenBodyWidget extends StatefulWidget {
  final Task? task;

  const TaskScreenBodyWidget({Key? key, this.task}) : super(key: key);

  @override
  _TaskScreenBodyState createState() => _TaskScreenBodyState();
}

class _TaskScreenBodyState extends State<TaskScreenBodyWidget> {
  late TaskViewModel _taskViewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _taskViewModel = Provider.of<TaskViewModel>(context, listen: true);

    final _day = DateTime.now().day.toString().length == 1
        ? '0${DateTime.now().day}'
        : '${DateTime.now().day}';
    final _month = DateTime.now().month.toString().length == 1
        ? '0${DateTime.now().month}'
        : '${DateTime.now().month}';
    final _year = '${DateTime.now().year}';

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
                child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                        top: 14.0,
                        left: 16.0,
                        right: 16.0,
                        bottom: MediaQuery.of(context).padding.bottom == 0.0
                            ? 20.0
                            : MediaQuery.of(context).padding.bottom),
                    children: [
                      /// STATUS
                      const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.status,
                          isSmall: true),
                      const SubtitleWidget(
                          padding: EdgeInsets.only(bottom: 16.0),
                          text: 'Завершенная'),

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
                      const SubtitleWidget(
                          padding: EdgeInsets.only(bottom: 16.0),
                          text: 'Имя Фамилия'),

                      /// TASK MANAGER
                      const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.taskManager,
                          isSmall: true),
                      const SubtitleWidget(
                          padding: EdgeInsets.only(bottom: 16.0),
                          text: 'Имя Фамилия'),

                      /// CO-EXECUTOR
                      const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.coExecutor,
                          isSmall: true),
                      const SubtitleWidget(
                          padding: EdgeInsets.only(bottom: 16.0),
                          text: 'Имя Фамилия'),

                      /// OBJECT
                      const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.object,
                          isSmall: true),
                      const SubtitleWidget(
                          padding: EdgeInsets.only(bottom: 16.0),
                          text: 'Название объекта'),

                      /// COMPANY
                      const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.company,
                          isSmall: true),
                      const SubtitleWidget(
                          padding: EdgeInsets.only(bottom: 16.0),
                          text: 'Название компании'),

                      /// DESCRTIPTION
                      const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.description,
                          isSmall: true),
                      const SubtitleWidget(
                          padding: EdgeInsets.only(bottom: 16.0),
                          text:
                              'Принимая во внимание показатели успешности, дальнейшее развитие различных форм деятельности влечет за собой процесс внедрения и модернизации форм воздействия.'),

                      /// FILE LIST
                      const TitleWidget(
                          padding: EdgeInsets.only(bottom: 10.0),
                          text: Titles.files,
                          isSmall: true),
                      ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return FileListItemWidget(
                                fileName: 'file.pdf', onRemoveTap: () => {});
                          }),
                      const SizedBox(height: 16.0),

                      /// EDIT TASK BUTTON
                      ButtonWidget(
                          title: Titles.edit,
                          margin: EdgeInsets.zero,
                          onTap: () =>
                              _taskViewModel.showTaskCreateScreenSheet(context))
                    ]))));
  }
}
