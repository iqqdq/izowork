// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:izowork/views/subtitle_widget.dart';
import 'package:izowork/views/title_widget.dart';

class ActionListItemWidget extends StatelessWidget {
  final String actionName;
  final String responsibleName;
  final DateTime dateTime;
  final int status;
  final String text;
  final VoidCallback onTap;

  const ActionListItemWidget(
      {Key? key,
      required this.actionName,
      required this.responsibleName,
      required this.dateTime,
      required this.status,
      required this.text,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            color: HexColors.white,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(width: 0.5, color: HexColors.grey30)),
        child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              /// ACTION NAME
              TitleWidget(text: actionName, padding: EdgeInsets.zero),
              const SizedBox(height: 10.0),

              /// DEADLINE
              Row(children: [
                const SubtitleWidget(
                    text: '${Titles.deadline}:', padding: EdgeInsets.zero),
                const SizedBox(width: 10.0),
                Expanded(
                  child: SubtitleWidget(
                      text: actionName,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.end,
                      padding: EdgeInsets.zero),
                )
              ]),
              const SizedBox(height: 10.0),

              /// RESPONSIBLE
              Row(children: [
                const SubtitleWidget(
                    text: '${Titles.responsible}:', padding: EdgeInsets.zero),
                const SizedBox(width: 10.0),
                Expanded(
                  child: SubtitleWidget(
                      text: responsibleName,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.end,
                      padding: EdgeInsets.zero),
                )
              ]),
              const SizedBox(height: 10.0),

              /// STATUS
              Row(children: [
                const SubtitleWidget(
                    text: '${Titles.status}:', padding: EdgeInsets.zero),
                const SizedBox(width: 10.0),
                Expanded(
                  child: SubtitleWidget(
                      text: status > -1 ? 'Название статуса' : '',
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.end,
                      padding: EdgeInsets.zero),
                )
              ]),
              const SizedBox(height: 10.0),
              const SeparatorWidget(),
              const SizedBox(height: 10.0),

              /// ACTION TEXT
              Text(text,
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
                  Image.asset('assets/ic_avatar.png'),
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
            ]));
  }
}
