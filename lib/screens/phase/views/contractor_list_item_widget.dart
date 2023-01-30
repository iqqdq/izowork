// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/subtitle_widget.dart';
import 'package:izowork/views/title_widget.dart';

class ContractorListItemWidget extends StatelessWidget {
  final VoidCallback onTap;

  const ContractorListItemWidget({Key? key, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                highlightColor: HexColors.grey20,
                splashColor: Colors.transparent,
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        border:
                            Border.all(width: 1.0, color: HexColors.grey30)),
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16.0),
                      shrinkWrap: true,
                      children: [
                        /// CONTRACTOR
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.contractor,
                            isSmall: true),
                        const SubtitleWidget(
                            padding: EdgeInsets.only(bottom: 16.0),
                            text: 'Название'),

                        /// DELIVERY TIME
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.deliveryTime,
                            isSmall: true),
                        const SubtitleWidget(
                            padding: EdgeInsets.only(bottom: 16.0),
                            text: 'Кол-во дней'),

                        /// PRODUCT
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.product,
                            isSmall: true),
                        const SubtitleWidget(
                            padding: EdgeInsets.only(bottom: 16.0),
                            text: 'Название'),

                        /// COUNT
                        const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.count,
                            isSmall: true),
                        const SubtitleWidget(
                            padding: EdgeInsets.zero, text: '1'),
                      ],
                    )),
                onTap: () => onTap())));
  }
}
