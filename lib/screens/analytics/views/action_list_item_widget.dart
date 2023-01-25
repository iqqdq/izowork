// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/deal.dart';
import 'package:izowork/entities/task.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:izowork/views/subtitle_widget.dart';
import 'package:izowork/views/title_widget.dart';

class ActionListItemWidget extends StatelessWidget {
  final Deal? deal;
  final Task? task;
  final VoidCallback onTap;

  const ActionListItemWidget(
      {Key? key, this.deal, this.task, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _day = DateTime.now().day.toString().length == 1
        ? '0${DateTime.now().day}'
        : '${DateTime.now().day}';
    final _month = DateTime.now().month.toString().length == 1
        ? '0${DateTime.now().month}'
        : '${DateTime.now().month}';
    final _year = '${DateTime.now().year}';

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
                      const TitleWidget(
                          text: 'Название задачи', padding: EdgeInsets.zero),
                      const SizedBox(height: 10.0),

                      /// DEADLINE
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SubtitleWidget(
                                text: '${Titles.terms}:',
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
                                  text: 'Аликпер',
                                  fontWeight: FontWeight.w700,
                                  textAlign: TextAlign.end,
                                  padding: EdgeInsets.zero),
                            )
                          ]),
                      const SizedBox(height: 10.0),

                      /// STATUS
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            SubtitleWidget(
                                text: '${Titles.status}:',
                                padding: EdgeInsets.zero),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: SubtitleWidget(
                                  text: 'Название статуса',
                                  fontWeight: FontWeight.w700,
                                  textAlign: TextAlign.end,
                                  padding: EdgeInsets.zero),
                            )
                          ]),
                      const SizedBox(height: 10.0),
                      const SeparatorWidget(),
                      const SizedBox(height: 10.0),

                      /// ACTION TEXT
                      Text(
                          'Мы вынуждены отталкиваться от того, что семантический разбор внешних противодействий играет определяющее значение для стандартных подходов. Прежде всего, перспективное планирование, в своём классическом представлении, допускает внедрение своевременного выполнения сверхзадачи.',
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
                            child: Text('Имя создателя карточки',
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
