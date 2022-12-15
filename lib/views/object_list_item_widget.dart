// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/object.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:izowork/views/subtitle_widget.dart';
import 'package:izowork/views/title_widget.dart';

class ObjectListItemWidget extends StatelessWidget {
  final Object object;
  final VoidCallback onTap;

  const ObjectListItemWidget(
      {Key? key, required this.object, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      /// OBJECT NAME
                      const TitleWidget(
                          text: 'Название объекта', padding: EdgeInsets.zero),
                      const SizedBox(height: 10.0),

                      /// ADDRESS
                      const SubtitleWidget(
                          text: 'г. Астана,\nул, Косым Жомарта, д, 185',
                          padding: EdgeInsets.zero),
                      const SizedBox(height: 10.0),
                      const SeparatorWidget(),
                      const SizedBox(height: 10.0),

                      /// MANAGER
                      const TitleWidget(
                          text: Titles.manager,
                          padding: EdgeInsets.zero,
                          isSmall: true),
                      const SizedBox(height: 10.0),

                      const SubtitleWidget(
                          text: 'Фахрутдинов Асмат Гилбарджанович',
                          padding: EdgeInsets.zero),

                      const SizedBox(height: 10.0),
                      const SeparatorWidget(),
                      const SizedBox(height: 10.0),

                      Row(children: [
                        /// REALIZATIONS
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                              TitleWidget(
                                  text: Titles.realizations,
                                  padding: EdgeInsets.zero,
                                  isSmall: true),
                              SizedBox(height: 2.0),
                              SubtitleWidget(
                                  text: '32 %', padding: EdgeInsets.zero)
                            ])),

                        /// EFFECTIVENESS
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                              TitleWidget(
                                  text: Titles.effectiveness,
                                  padding: EdgeInsets.zero,
                                  isSmall: true),
                              SizedBox(height: 2.0),
                              SubtitleWidget(
                                  text: '32 %', padding: EdgeInsets.zero)
                            ])),
                      ])
                    ]),
                onTap: () => onTap())));
  }
}
