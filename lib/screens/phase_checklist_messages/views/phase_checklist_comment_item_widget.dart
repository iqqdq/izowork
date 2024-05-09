import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:izowork/api/api.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/views/views.dart';

class PhaseChecklistMessageItemWidget extends StatelessWidget {
  final PhaseChecklistMessage phaseChecklistMessage;
  final VoidCallback onUserTap;

  const PhaseChecklistMessageItemWidget({
    Key? key,
    required this.phaseChecklistMessage,
    required this.onUserTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? _url = phaseChecklistMessage.user.avatar;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 14.0,
      ),
      color: HexColors.white,
      child: Column(children: [
        GestureDetector(
          child: Row(children: [
            /// USER AVATAR
            Stack(children: [
              Container(
                width: 30.0,
                height: 30.0,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: SvgPicture.asset(
                  'assets/ic_avatar.svg',
                  color: HexColors.grey30,
                  width: 40.0,
                  height: 40.0,
                  fit: BoxFit.cover,
                ),
              ),

              /// AVATAR
              _url == null
                  ? Container()
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: CachedNetworkImage(
                        cacheKey: _url,
                        imageUrl: avatarUrl + _url,
                        width: 30.0,
                        height: 30.0,
                        memCacheWidth: 30 *
                            MediaQuery.of(context).devicePixelRatio.round(),
                        fit: BoxFit.cover,
                      ),
                    ),
            ]),
            const SizedBox(width: 12.0),

            /// USER NAME
            Expanded(
              child: Text(
                phaseChecklistMessage.user.name,
                maxLines: 1,
                style: TextStyle(
                  color: HexColors.grey50,
                  fontSize: 14.0,
                  fontFamily: 'PT Root UI',
                  fontWeight: FontWeight.w700,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ]),
          onTap: () => onUserTap(),
        ),
        const SizedBox(height: 8.0),

        /// COMMENT
        SelectionArea(
          child: Text(phaseChecklistMessage.body,
              style: TextStyle(
                color: HexColors.black,
                fontSize: 14.0,
                fontFamily: 'PT Root UI',
                fontWeight: FontWeight.w400,
              )),
        ),
        const SizedBox(height: 8.0),

        /// DATE
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TitleWidget(
              text: DateTimeFormatter().formatDateTimeToString(
                dateTime: phaseChecklistMessage.createdAt,
                showTime: true,
                showMonthName: true,
              ),
              padding: EdgeInsets.zero,
              textAlign: TextAlign.end,
              isSmall: true,
            ),
          ],
        )
      ]),
    );
  }
}
