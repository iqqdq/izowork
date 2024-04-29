// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/locale.dart';
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
    initializeDateFormatting(locale, null);

    // chat.lastMessage == null ? null : chat.lastMessage!.createdAt.toUtc().toLocal();

    bool _isToday =
        phaseChecklistComment?.createdAt.year == DateTime.now().year &&
            phaseChecklistComment?.createdAt.month == DateTime.now().month &&
            phaseChecklistComment?.createdAt.day == DateTime.now().day;

    bool _isYesterday = phaseChecklistComment?.createdAt.year ==
            DateTime.now().subtract(const Duration(days: 1)).year &&
        phaseChecklistComment?.createdAt.month ==
            DateTime.now().subtract(const Duration(days: 1)).month &&
        phaseChecklistComment?.createdAt.day ==
            DateTime.now().subtract(const Duration(days: 1)).day;

    String _day = phaseChecklistComment?.createdAt.day.toString().length == 1
        ? '0${phaseChecklistComment?.createdAt.day}'
        : '${phaseChecklistComment?.createdAt.day}';
    String _month = phaseChecklistComment == null
        ? ''
        : DateFormat.MMM(locale).format(phaseChecklistComment!.createdAt);
    String _year = phaseChecklistComment?.createdAt.year == DateTime.now().year
        ? ''
        : '${phaseChecklistComment?.createdAt.year}';

    String _hour = phaseChecklistComment?.createdAt.hour.toString().length == 1
        ? '0${phaseChecklistComment?.createdAt.hour}'
        : '${phaseChecklistComment?.createdAt.hour}';

    String _minute =
        phaseChecklistComment?.createdAt.minute.toString().length == 1
            ? '0${phaseChecklistComment?.createdAt.minute}'
            : '${phaseChecklistComment?.createdAt.minute}';

    // bool isFile = chat.lastMessage == null ? false : !isAudio && chat.lastMessage!.files.isNotEmpty;

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
              text: _isYesterday
                  ? 'Вчера, $_hour:$_minute'
                  : _isToday
                      ? 'Сегодня, $_hour:$_minute'
                      : _year.isEmpty
                          ? '$_day $_month, $_hour:$_minute'
                          : '$_day $_month $_year, $_hour:$_minute',
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
