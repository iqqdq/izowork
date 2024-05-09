// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';

import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/views/subtitle_widget.dart';
import 'package:izowork/views/views.dart';

class ContractorListItemWidget extends StatelessWidget {
  final PhaseContractor phaseContractor;
  final VoidCallback onTap;

  const ContractorListItemWidget({
    Key? key,
    required this.phaseContractor,
    required this.onTap,
  }) : super(key: key);

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
                      border: Border.all(width: 1.0, color: HexColors.grey30)),
                  child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16.0),
                      shrinkWrap: true,
                      children: [
                        /// CONTRACTOR
                        const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.contractor,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          text: phaseContractor.contractor?.name ?? '-',
                        ),

                        /// RESPONSIBLE
                        const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.responsible,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          text: phaseContractor.responsible?.name ?? '-',
                        ),

                        /// CO-EXECUTOR
                        const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.coExecutor,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          text: phaseContractor.coExecutor?.name ?? '-',
                        ),

                        /// OBSERVER
                        const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.observer,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: EdgeInsets.zero,
                          text: phaseContractor.observer?.name ?? '-',
                        ),
                      ])),
              onTap: () => onTap(),
            )));
  }
}
