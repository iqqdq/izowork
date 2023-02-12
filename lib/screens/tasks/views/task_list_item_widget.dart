import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/task.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:izowork/views/subtitle_widget.dart';
import 'package:izowork/views/title_widget.dart';

class TaskListItemWidget extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskListItemWidget({Key? key, required this.task, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _day = task.deadline.day.toString().length == 1
        ? '0${task.deadline.day}'
        : '${task.deadline.day}';
    final _month = task.deadline.month.toString().length == 1
        ? '0${task.deadline.month}'
        : '${task.deadline.month}';
    final _year = '${task.deadline.year}';

    return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(width: 0.5, color: HexColors.grey30)),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                highlightColor: HexColors.grey20,
                splashColor: Colors.transparent,
                borderRadius: BorderRadius.circular(16.0),
                child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      /// ACTION NAME
                      TitleWidget(text: task.name, padding: EdgeInsets.zero),
                      const SizedBox(height: 10.0),

                      /// DEADLINE
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SubtitleWidget(
                                text: '${Titles.deadline}:',
                                padding: EdgeInsets.zero),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: SubtitleWidget(
                                  text: '$_day.$_month.$_year',
                                  fontWeight: FontWeight.w700,
                                  textAlign: TextAlign.end,
                                  padding: EdgeInsets.zero),
                            )
                          ]),
                      const SizedBox(height: 10.0),

                      /// RESPONSIBLE
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            SubtitleWidget(
                                text: '${Titles.responsible}:',
                                padding: EdgeInsets.zero),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: SubtitleWidget(
                                  text: '???',
                                  fontWeight: FontWeight.w700,
                                  textAlign: TextAlign.end,
                                  padding: EdgeInsets.zero),
                            )
                          ]),
                      const SizedBox(height: 10.0),

                      /// OBJECT
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            SubtitleWidget(
                                text: '${Titles.object}:',
                                padding: EdgeInsets.zero),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: SubtitleWidget(
                                  text: '???',
                                  fontWeight: FontWeight.w700,
                                  textAlign: TextAlign.end,
                                  padding: EdgeInsets.zero),
                            )
                          ]),
                      const SizedBox(height: 10.0),
                      const SeparatorWidget(),
                      const SizedBox(height: 10.0),

                      /// ACTION TEXT
                      Text(task.description,
                          style: TextStyle(
                              color: HexColors.black,
                              fontSize: 14.0,
                              fontFamily: 'PT Root UI',
                              fontWeight: FontWeight.w400)),
                      const SizedBox(height: 10.0),

                      /// CREATOR
                      Row(children: [
                        /// CREATOR AVATAR
                        Stack(children: [
                          SvgPicture.asset('assets/ic_avatar.svg',
                              color: HexColors.grey40,
                              width: 24.0,
                              height: 24.0,
                              fit: BoxFit.cover),
                          // ClipRRect(
                          //   borderRadius: BorderRadius.circular(12.0),
                          //   child:
                          // CachedNetworkImage(imageUrl: '', width: 24.0, height: 24.0, fit: BoxFit.cover)),
                        ]),
                        const SizedBox(width: 10.0),

                        /// CREATOR NAME
                        Expanded(
                            child: Text('???',
                                style: TextStyle(
                                    color: HexColors.grey50,
                                    fontSize: 14.0,
                                    fontFamily: 'PT Root UI',
                                    fontWeight: FontWeight.w700)))
                      ])
                    ]),
                onTap: () => onTap())));
  }
}
