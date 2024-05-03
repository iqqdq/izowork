import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:izowork/components/date_time_string_formatter.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/entities/response/phase_checklist.dart';
import 'package:izowork/views/title_widget.dart';

class PhaseChecklistCommentItemWidget extends StatelessWidget {
  final PhaseChecklistComment? phaseChecklistComment;
  final VoidCallback onUserTap;

  const PhaseChecklistCommentItemWidget({
    Key? key,
    this.phaseChecklistComment,
    required this.onUserTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              // TODO: - PHASE CHECKLIST COMMENT AVATAR
              // _url == null
              //     ? Container()
              //     : ClipRRect(
              //         borderRadius: BorderRadius.circular(20.0),
              //         child: CachedNetworkImage(
              //           cacheKey: _url,
              //           imageUrl: avatarUrl + _url,
              //           width: 40.0,
              //           height: 40.0,
              //           memCacheWidth: 40 *
              //               MediaQuery.of(context)
              //                   .devicePixelRatio
              //                   .round(),
              //           fit: BoxFit.cover,
              //         ),
              //       ),
            ]),
            const SizedBox(width: 12.0),

            /// USER NAME
            Expanded(
              child: Text(
                'Имя Фамилия',
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
          child: Text(phaseChecklistComment?.body ?? '',
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
              text: phaseChecklistComment == null
                  ? ''
                  : DateTimeFormatter().formatDateTimeToString(
                      dateTime: phaseChecklistComment!.createdAt,
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
