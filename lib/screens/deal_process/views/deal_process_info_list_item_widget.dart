// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/deal_process_info.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/views/file_list_widget.dart';
import 'package:izowork/views/subtitle_widget.dart';
import 'package:izowork/views/title_widget.dart';

class DealProcessInfoListItemWidget extends StatelessWidget {
  final DealProcessInfo information;
  final VoidCallback onUserTap;
  final Function(int) onFileTap;

  const DealProcessInfoListItemWidget(
      {Key? key,
      required this.information,
      required this.onUserTap,
      required this.onFileTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.parse(information.createdAt).toUtc().toLocal();

    final _day = dateTime.day.toString().length == 1
        ? '0${dateTime.day}'
        : '${dateTime.day}';
    final _month = dateTime.month.toString().length == 1
        ? '0${dateTime.month}'
        : '${dateTime.month}';
    final _year = '${dateTime.year}';

    String? _url = information.user == null
        ? null
        : information.user!.avatar == null
            ? null
            : information.user!.avatar!.isEmpty
                ? null
                : information.user!.avatar;

    return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(width: 0.5, color: HexColors.grey30)),
        child: ListView(
            padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
                bottom: information.files.isEmpty ? 16.0 : 0.0),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              /// AVATAR
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(
                    child: GestureDetector(
                        onTap: () => onUserTap(),
                        child: Row(children: [
                          Stack(children: [
                            SvgPicture.asset('assets/ic_avatar.svg',
                                color: HexColors.grey40,
                                width: 24.0,
                                height: 24.0,
                                fit: BoxFit.cover),
                            _url == null
                                ? Container()
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: CachedNetworkImage(
                                        cacheKey: _url,
                                        imageUrl: avatarUrl + _url,
                                        width: 24.0,
                                        height: 24.0,
                                        memCacheWidth: 24 *
                                            MediaQuery.of(context)
                                                .devicePixelRatio
                                                .round(),
                                        fit: BoxFit.cover)),
                          ]),
                          const SizedBox(width: 10.0),

                          /// NAME
                          Expanded(
                              child: Text(
                            information.user?.name ?? '-',
                            style: TextStyle(
                                color: HexColors.black,
                                fontSize: 14.0,
                                fontFamily: 'PT Root UI',
                                fontWeight: FontWeight.w600),
                          )),
                          const SizedBox(width: 10.0),
                        ]))),

                /// DATE
                SubtitleWidget(
                    text: '$_day.$_month.$_year',
                    fontWeight: FontWeight.w500,
                    padding: EdgeInsets.zero),
              ]),
              const TitleWidget(
                  text: Titles.description,
                  isSmall: true,
                  padding: EdgeInsets.only(top: 10.0, bottom: 6.0)),

              /// DESCRIPTION

              Text(information.description,
                  style: TextStyle(
                      fontSize: 14.0,
                      color: HexColors.black,
                      fontFamily: 'PT Root UI')),
              information.files.isEmpty
                  ? Container()
                  : const TitleWidget(
                      text: Titles.files,
                      isSmall: true,
                      padding: EdgeInsets.only(top: 16.0, bottom: 10.0)),

              /// FILE LIST
              ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: information.files.length,
                  itemBuilder: (context, index) {
                    return FileListItemWidget(
                      fileName: information.files[index].name,
                      onTap: () => onFileTap(index),
                    );
                  })
            ]));
  }
}
