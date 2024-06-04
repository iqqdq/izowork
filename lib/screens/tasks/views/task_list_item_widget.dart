import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/views/views.dart';

class TaskListItemWidget extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskListItemWidget({
    Key? key,
    required this.task,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.parse(task.deadline).toUtc().toLocal();

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
                      TitleWidget(
                        text: task.name,
                        padding: EdgeInsets.zero,
                        nonSelectable: true,
                      ),
                      const SizedBox(height: 10.0),

                      /// DEADLINE
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SubtitleWidget(
                              text: '${Titles.deadline}:',
                              padding: EdgeInsets.zero,
                              nonSelectable: true,
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: SubtitleWidget(
                                text:
                                    DateTimeFormatter().formatDateTimeToString(
                                  dateTime: dateTime,
                                  showTime: false,
                                  showMonthName: false,
                                ),
                                fontWeight: FontWeight.w700,
                                textAlign: TextAlign.end,
                                padding: EdgeInsets.zero,
                                nonSelectable: true,
                              ),
                            )
                          ]),
                      const SizedBox(height: 10.0),

                      /// RESPONSIBLE
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SubtitleWidget(
                              text: '${Titles.responsible}:',
                              padding: EdgeInsets.zero,
                              nonSelectable: true,
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: SubtitleWidget(
                                text: task.responsible?.name ?? '-',
                                fontWeight: FontWeight.w700,
                                textAlign: TextAlign.end,
                                padding: EdgeInsets.zero,
                                nonSelectable: true,
                              ),
                            )
                          ]),
                      const SizedBox(height: 10.0),

                      /// OBJECT
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SubtitleWidget(
                              text: '${Titles.object}:',
                              padding: EdgeInsets.zero,
                              nonSelectable: true,
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: SubtitleWidget(
                                text: task.object?.name ?? '-',
                                fontWeight: FontWeight.w700,
                                textAlign: TextAlign.end,
                                padding: EdgeInsets.zero,
                                nonSelectable: true,
                              ),
                            )
                          ]),
                      const SizedBox(height: 10.0),
                      const SeparatorWidget(),
                      SizedBox(height: task.description.isEmpty ? 0.0 : 10.0),

                      /// ACTION TEXT
                      SubtitleWidget(
                        text: task.description,
                        padding: EdgeInsets.zero,
                        nonSelectable: true,
                      ),
                      SizedBox(height: task.description.isEmpty ? 0.0 : 10.0),
                      task.description.isEmpty
                          ? Container()
                          : const SeparatorWidget(),
                      SizedBox(height: task.description.isEmpty ? 0.0 : 20.0),

                      /// USER
                      Row(children: [
                        /// USER AVATAR
                        Stack(children: [
                          task.taskManager == null
                              ? SvgPicture.asset('assets/ic_avatar.svg',
                                  // ignore: deprecated_member_use
                                  color: HexColors.grey40,
                                  width: 24.0,
                                  height: 24.0,
                                  fit: BoxFit.cover)
                              : task.taskManager!.avatar == null
                                  ? SvgPicture.asset('assets/ic_avatar.svg',
                                      colorFilter: ColorFilter.mode(
                                        HexColors.grey40,
                                        BlendMode.srcIn,
                                      ),
                                      width: 24.0,
                                      height: 24.0,
                                      fit: BoxFit.cover)
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: CachedNetworkImage(
                                          imageUrl: avatarUrl +
                                              task.taskManager!.avatar!,
                                          width: 24.0,
                                          height: 24.0,
                                          memCacheWidth: 24 *
                                              (MediaQuery.of(context)
                                                      .devicePixelRatio)
                                                  .round(),
                                          fit: BoxFit.cover)),
                        ]),
                        const SizedBox(width: 10.0),

                        /// USER NAME
                        task.taskManager == null
                            ? Container()
                            : Expanded(
                                child: Text(task.taskManager!.name,
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
