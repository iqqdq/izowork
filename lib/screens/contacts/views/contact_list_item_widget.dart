import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/contact.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/views/status_widget.dart';
import 'package:izowork/views/subtitle_widget.dart';
import 'package:izowork/views/title_widget.dart';

class ContactListItemWidget extends StatelessWidget {
  final Contact contact;
  final VoidCallback onContactTap;
  final VoidCallback onPhoneTap;
  final VoidCallback onLinkTap;

  const ContactListItemWidget(
      {Key? key,
      required this.contact,
      required this.onContactTap,
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
            child: InkWell(
                highlightColor: HexColors.grey20,
                splashColor: Colors.transparent,
                borderRadius: BorderRadius.circular(16.0),
                child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Row(children: [
                        /// CONTACT AVATAR
                        Stack(children: [
                          SvgPicture.asset('assets/ic_avatar.svg',
                              color: HexColors.grey40,
                              width: 40.0,
                              height: 40.0,
                              fit: BoxFit.cover),
                          contact.avatar == null
                              ? Container()
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: CachedNetworkImage(
                                      imageUrl:
                                          contactAvatarUrl + contact.avatar!,
                                      width: 40.0,
                                      height: 40.0,
                                      memCacheWidth: 40 *
                                          MediaQuery.of(context)
                                              .devicePixelRatio
                                              .round(),
                                      fit: BoxFit.cover)),
                        ]),
                        const SizedBox(width: 10.0),

                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              /// CONTACT NAME
                              Text(contact.name,
                                  style: TextStyle(
                                      color: HexColors.black,
                                      fontSize: 14.0,
                                      fontFamily: 'PT Root UI',
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2.0),

                              /// CONTACT SPECIALIZATION
                              Text(contact.post ?? '-',
                                  style: TextStyle(
                                      color: HexColors.grey50,
                                      fontSize: 12.0,
                                      fontFamily: 'PT Root UI')),
                            ]))
                      ]),
                      const SizedBox(height: 16.0),
                      Row(children: [
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              const TitleWidget(
                                  text: Titles.companyName,
                                  padding: EdgeInsets.zero,
                                  isSmall: true),
                              const SizedBox(height: 4.0),

                              /// COMPANY NAME
                              SubtitleWidget(
                                  text: contact.company?.name ?? '-',
                                  padding: EdgeInsets.zero,
                                  fontWeight: FontWeight.normal),
                            ])),
                        const SizedBox(width: 10.0),

                        /// TAG
                        contact.company == null
                            ? Container()
                            : StatusWidget(
                                title: contact.company?.type ?? '-',
                                status: contact.company?.type == 'Поставщик'
                                    ? 0
                                    : contact.company?.type == 'Проектировщик'
                                        ? 1
                                        : 2)
                      ]),
                      const SizedBox(height: 10.0),
                      const TitleWidget(
                          text: Titles.phone,
                          padding: EdgeInsets.zero,
                          isSmall: true),
                      const SizedBox(height: 4.0),

                      /// PHONE
                      SubtitleWidget(
                          text: contact.phone ?? '-',
                          padding: EdgeInsets.zero,
                          fontWeight: FontWeight.normal),
                      const SizedBox(height: 10.0),
                      const TitleWidget(
                          text: Titles.email,
                          padding: EdgeInsets.zero,
                          isSmall: true),
                      const SizedBox(height: 4.0),

                      /// EMAIL
                      SubtitleWidget(
                          text: contact.email ?? '-',
                          padding: EdgeInsets.zero,
                          fontWeight: FontWeight.normal),
                      const SizedBox(height: 10.0),

                      /// LINK LIST VIEW
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: contact.social.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: InkWell(
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: Text(contact.social[index],
                                        style: TextStyle(
                                            color: HexColors.primaryDark,
                                            fontSize: 14.0,
                                            fontFamily: 'PT Root UI',
                                            fontWeight: FontWeight.w600,
                                            decoration:
                                                TextDecoration.underline)),
                                    onTap: () => onLinkTap()));
                          })
                    ]),
                onTap: () => onContactTap())));
  }
}
