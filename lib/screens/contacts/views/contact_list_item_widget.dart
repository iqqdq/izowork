import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/status_widget.dart';
import 'package:izowork/views/subtitle_widget.dart';
import 'package:izowork/views/title_widget.dart';

class ContactListItemWidget extends StatelessWidget {
  final VoidCallback onUserTap;
  final VoidCallback onPhoneTap;
  final VoidCallback onLinkTap;

  const ContactListItemWidget(
      {Key? key,
      required this.onUserTap,
      required this.onPhoneTap,
      required this.onLinkTap})
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
            child: ListView(
                padding: const EdgeInsets.all(16.0),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  /// STAFF
                  InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(16.0),
                      child: Row(children: [
                        /// STAFF AVATAR
                        Stack(children: [
                          SvgPicture.asset('assets/ic_avatar.svg',
                              color: HexColors.grey40,
                              width: 40.0,
                              height: 40.0,
                              fit: BoxFit.cover),
                          // ClipRRect(
                          //   borderRadius: BorderRadius.circular(12.0),
                          //   child:
                          // CachedNetworkImage(imageUrl: '', width: 40.0, height: 40.0, fit: BoxFit.cover)),
                        ]),
                        const SizedBox(width: 10.0),

                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              /// STAFF NAME
                              Text('Имя сотрудника',
                                  style: TextStyle(
                                      color: HexColors.black,
                                      fontSize: 14.0,
                                      fontFamily: 'PT Root UI',
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2.0),

                              /// STAFF SPECIALIZATION
                              Text('Специальность',
                                  style: TextStyle(
                                      color: HexColors.grey50,
                                      fontSize: 12.0,
                                      fontFamily: 'PT Root UI')),
                            ]))
                      ]),
                      onTap: () => onUserTap()),
                  const SizedBox(height: 16.0),
                  Row(children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                          TitleWidget(
                              text: Titles.companyName,
                              padding: EdgeInsets.zero,
                              isSmall: true),
                          SizedBox(height: 4.0),

                          /// COMPANY NAME
                          SubtitleWidget(
                              text: 'АрхитектСтрой',
                              padding: EdgeInsets.zero,
                              fontWeight: FontWeight.normal),
                        ])),
                    const SizedBox(width: 16.0),

                    /// TAG
                    const StatusWidget(title: 'Поставщик', status: 0)
                  ]),
                  const SizedBox(height: 10.0),
                  const TitleWidget(
                      text: Titles.phone,
                      padding: EdgeInsets.zero,
                      isSmall: true),
                  const SizedBox(height: 4.0),

                  /// PHONE
                  const SubtitleWidget(
                      text: '+7 999 99 99 99',
                      padding: EdgeInsets.zero,
                      fontWeight: FontWeight.normal),
                  const SizedBox(height: 10.0),
                  const TitleWidget(
                      text: Titles.email,
                      padding: EdgeInsets.zero,
                      isSmall: true),
                  const SizedBox(height: 4.0),

                  /// EMAIL
                  const SubtitleWidget(
                      text: 'example@gmail.com',
                      padding: EdgeInsets.zero,
                      fontWeight: FontWeight.normal),
                  const SizedBox(height: 10.0),

                  /// LINK LIST VIEW
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                borderRadius: BorderRadius.circular(16.0),
                                child: Text('https://facebook.com/yur_T',
                                    style: TextStyle(
                                        color: HexColors.primaryDark,
                                        fontSize: 14.0,
                                        fontFamily: 'PT Root UI',
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline)),
                                onTap: () => onLinkTap()));
                      })
                ])));
  }
}
