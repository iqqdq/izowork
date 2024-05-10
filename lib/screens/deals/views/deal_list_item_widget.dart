// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/views/views.dart';

class DealListItemWidget extends StatelessWidget {
  final Deal deal;
  final VoidCallback onTap;

  const DealListItemWidget({
    Key? key,
    required this.deal,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.parse(deal.finishAt).toUtc().toLocal();

    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          width: 0.5,
          color: HexColors.grey30,
        ),
      ),
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
                /// DEAL NAME
                TitleWidget(
                  text: '${Titles.deal} ${deal.number}',
                  padding: EdgeInsets.zero,
                  nonSelectable: true,
                ),
                const SizedBox(height: 10.0),

                /// DEADLINE
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SubtitleWidget(
                    text: '${Titles.deadline}:',
                    padding: EdgeInsets.zero,
                    nonSelectable: true,
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: SubtitleWidget(
                      text: DateTimeFormatter().formatDateTimeToString(
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
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SubtitleWidget(
                    text: '${Titles.responsible}:',
                    padding: EdgeInsets.zero,
                    nonSelectable: true,
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: SubtitleWidget(
                      text: deal.responsible?.name ?? '-',
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.end,
                      padding: EdgeInsets.zero,
                      nonSelectable: true,
                    ),
                  )
                ]),
                const SizedBox(height: 10.0),

                /// COMPANY
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SubtitleWidget(
                    text: '${Titles.company}:',
                    padding: EdgeInsets.zero,
                    nonSelectable: true,
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: SubtitleWidget(
                      text: deal.company?.name ?? '-',
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.end,
                      padding: EdgeInsets.zero,
                      nonSelectable: true,
                    ),
                  )
                ]),
                const SizedBox(height: 10.0),

                /// STATUS
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SubtitleWidget(
                    text: '${Titles.status}:',
                    padding: EdgeInsets.zero,
                    nonSelectable: true,
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: SubtitleWidget(
                      text: deal.closed ? 'Закрыта' : 'В работе',
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.end,
                      padding: EdgeInsets.zero,
                      nonSelectable: true,
                    ),
                  )
                ]),
                const SizedBox(height: 10.0),

                /// OBJECT
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SubtitleWidget(
                    text: '${Titles.object}:',
                    padding: EdgeInsets.zero,
                    nonSelectable: true,
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: SubtitleWidget(
                      text: deal.object?.name ?? '-',
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.end,
                      padding: EdgeInsets.zero,
                      nonSelectable: true,
                    ),
                  )
                ]),
                const SizedBox(height: 10.0),

                /// STAGE
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SubtitleWidget(
                    text: '${Titles.stage}:',
                    padding: EdgeInsets.zero,
                    nonSelectable: true,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: SubtitleWidget(
                      text: deal.dealStage?.name ?? '-',
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.end,
                      padding: EdgeInsets.zero,
                      nonSelectable: true,
                    ),
                  )
                ])
              ]),
          onTap: () => onTap(),
        ),
      ),
    );
  }
}
