import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/views/views.dart';

class CompaniesListItemWidget extends StatelessWidget {
  final Company company;
  final VoidCallback onTap;

  const CompaniesListItemWidget(
      {Key? key, required this.company, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(width: 0.5, color: HexColors.grey30)),
        child: InkWell(
            highlightColor: HexColors.grey20,
            splashColor: Colors.transparent,
            borderRadius: BorderRadius.circular(16.0),
            onTap: () => onTap(),
            child: ListView(
                padding: const EdgeInsets.all(16.0),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Row(children: [
                    /// AVATAR
                    AvatarWidget(
                      url: companyMedialUrl,
                      endpoint: company.image,
                      size: 40.0,
                    ),

                    const SizedBox(width: 10.0),

                    /// NAME
                    Expanded(
                        child: Text(company.name,
                            style: TextStyle(
                                color: HexColors.black,
                                fontSize: 14.0,
                                fontFamily: 'PT Root UI',
                                fontWeight: FontWeight.bold))),
                    const SizedBox(height: 2.0),
                  ]),
                  const SizedBox(height: 10.0),
                  Row(children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          /// MANAGER
                          const TitleWidget(
                            padding: EdgeInsets.only(bottom: 4.0),
                            text: Titles.manager,
                            isSmall: true,
                          ),
                          SubtitleWidget(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              text: company.manager?.name ?? '-'),

                          /// ADDRESS
                          const TitleWidget(
                            text: Titles.address,
                            padding: EdgeInsets.zero,
                            isSmall: true,
                          ),
                          const SizedBox(height: 4.0),

                          SubtitleWidget(
                            text: company.address ?? '-',
                            padding: EdgeInsets.zero,
                            fontWeight: FontWeight.normal,
                          ),
                          const SizedBox(height: 12.0),
                        ]))
                  ]),
                  const SizedBox(height: 10.0),

                  /// TAG
                  Row(children: [
                    StatusWidget(
                        title: company.type,
                        status: company.type == 'Поставщик'
                            ? 0
                            : company.type == 'Проектировщик'
                                ? 1
                                : 2)
                  ])
                ])));
  }
}
