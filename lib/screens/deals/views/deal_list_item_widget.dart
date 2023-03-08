// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/deal.dart';
import 'package:izowork/views/subtitle_widget.dart';
import 'package:izowork/views/title_widget.dart';

class DealListItemWidget extends StatelessWidget {
  final Deal deal;
  final VoidCallback onTap;

  const DealListItemWidget({Key? key, required this.deal, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.parse(deal.finishAt);

    final _day = dateTime.day.toString().length == 1
        ? '0${dateTime.day}'
        : '${dateTime.day}';
    final _month = dateTime.month.toString().length == 1
        ? '0${dateTime.month}'
        : '${dateTime.month}';
    final _year = '${dateTime.year}';

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
                      /// DEAL NAME
                      TitleWidget(
                          text: '${Titles.deal} ${deal.number}',
                          padding: EdgeInsets.zero),
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
                          children: [
                            const SubtitleWidget(
                                text: '${Titles.responsible}:',
                                padding: EdgeInsets.zero),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: SubtitleWidget(
                                  text: deal.responsible?.name ?? '-',
                                  fontWeight: FontWeight.w700,
                                  textAlign: TextAlign.end,
                                  padding: EdgeInsets.zero),
                            )
                          ]),
                      const SizedBox(height: 10.0),

                      /// COMPANY
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SubtitleWidget(
                                text: '${Titles.company}:',
                                padding: EdgeInsets.zero),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: SubtitleWidget(
                                  text: deal.company?.name ?? '-',
                                  fontWeight: FontWeight.w700,
                                  textAlign: TextAlign.end,
                                  padding: EdgeInsets.zero),
                            )
                          ]),
                      const SizedBox(height: 10.0),

                      /// STATUS
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SubtitleWidget(
                                text: '${Titles.status}:',
                                padding: EdgeInsets.zero),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: SubtitleWidget(
                                  text: deal.closed ? 'Закрыта' : 'В работе',
                                  fontWeight: FontWeight.w700,
                                  textAlign: TextAlign.end,
                                  padding: EdgeInsets.zero),
                            )
                          ]),
                      const SizedBox(height: 10.0),

                      /// OBJECT
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SubtitleWidget(
                                text: '${Titles.object}:',
                                padding: EdgeInsets.zero),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: SubtitleWidget(
                                  text: deal.object?.name ?? '-',
                                  fontWeight: FontWeight.w700,
                                  textAlign: TextAlign.end,
                                  padding: EdgeInsets.zero),
                            )
                          ]),
                      const SizedBox(height: 10.0),

                      /// STAGE
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            SubtitleWidget(
                                text: '${Titles.stage}:',
                                padding: EdgeInsets.zero),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: SubtitleWidget(
                                  text: '???',
                                  fontWeight: FontWeight.w700,
                                  textAlign: TextAlign.end,
                                  padding: EdgeInsets.zero),
                            )
                          ])
                    ]),
                onTap: () => onTap())));
  }
}
