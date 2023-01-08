import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/status_widget.dart';
import 'package:izowork/views/subtitle_widget.dart';
import 'package:izowork/views/title_widget.dart';

class CompaniesListItemWidget extends StatelessWidget {
  final VoidCallback onTap;

  const CompaniesListItemWidget({Key? key, required this.onTap})
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
                  /// STAFF
                  Row(children: [
                    /// STAFF AVATAR
                    Stack(children: [
                      SvgPicture.asset('assets/ic_avatar.svg',
                          color: HexColors.grey40,
                          width: 40.0,
                          height: 40.0,
                          fit: BoxFit.cover),
                      //   ClipRRect(
                      //   borderRadius: BorderRadius.circular(12.0),
                      //   child:
                      // CachedNetworkImage(imageUrl: '', width: 40.0, height: 40.0, fit: BoxFit.cover)),
                    ]),
                    const SizedBox(width: 10.0),

                    /// COMPANY NAME
                    Expanded(
                        child: Text('Арзамас Холдинг',
                            maxLines: 2,
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
                            children: const [
                          TitleWidget(
                              text: Titles.address,
                              padding: EdgeInsets.zero,
                              isSmall: true),
                          SizedBox(height: 4.0),

                          /// ADDRESS
                          SubtitleWidget(
                              text: 'г. Астана, ул. Сталелитейная, д. 185',
                              padding: EdgeInsets.zero,
                              fontWeight: FontWeight.normal),
                        ]))
                  ]),
                  const SizedBox(height: 10.0),

                  /// TAG
                  Row(children: const [
                    StatusWidget(title: 'Поставщик', status: 0)
                  ])
                ])));
  }
}
