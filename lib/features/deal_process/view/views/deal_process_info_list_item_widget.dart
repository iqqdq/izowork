// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/views/views.dart';

class DealProcessInfoListItemWidget extends StatelessWidget {
  final DealProcessInfo information;
  final VoidCallback onUserTap;
  final Function(int) onFileTap;

  const DealProcessInfoListItemWidget({
    Key? key,
    required this.information,
    required this.onUserTap,
    required this.onFileTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? url = information.user == null
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => onUserTap(),
                    child: Row(children: [
                      /// AVATAR
                      AvatarWidget(
                        url: avatarUrl,
                        endpoint: url,
                        size: 24.0,
                      ),

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
                    ]),
                  ),
                ),

                /// DATE
                SubtitleWidget(
                  text: DateTimeFormatter().formatDateTimeToString(
                    dateTime: information.createdAt,
                    showTime: false,
                    showMonthName: false,
                  ),
                  fontWeight: FontWeight.w500,
                  padding: EdgeInsets.zero,
                ),
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
                      padding: EdgeInsets.only(top: 16.0, bottom: 10.0),
                    ),

              /// FILE LIST
              ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: information.files.length,
                  itemBuilder: (context, index) {
                    final file = information.files[index];

                    return FileListItemWidget(
                      key: ValueKey(file.id),
                      fileName: file.name,
                      onTap: () => onFileTap(index),
                    );
                  })
            ]));
  }
}
