// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/locale.dart';
import 'package:izowork/views/title_widget.dart';

class PhaseChecklistCommentItemWidget extends StatelessWidget {
  final VoidCallback onUserTap;

  const PhaseChecklistCommentItemWidget({
    Key? key,
    required this.onUserTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting(locale, null);

    DateTime? dateTime = DateTime.now();
    // chat.lastMessage == null ? null : chat.lastMessage!.createdAt.toUtc().toLocal();

    bool _isToday = dateTime?.year == DateTime.now().year &&
        dateTime?.month == DateTime.now().month &&
        dateTime?.day == DateTime.now().day;

    bool _isYesterday = dateTime?.year ==
            DateTime.now().subtract(const Duration(days: 1)).year &&
        dateTime?.month ==
            DateTime.now().subtract(const Duration(days: 1)).month &&
        dateTime?.day == DateTime.now().subtract(const Duration(days: 1)).day;

    String _day = dateTime?.day.toString().length == 1
        ? '0${dateTime?.day}'
        : '${dateTime?.day}';
    String _month =
        dateTime == null ? '' : DateFormat.MMM(locale).format(dateTime);
    String _year =
        dateTime?.year == DateTime.now().year ? '' : '${dateTime?.year}';

    String _hour = dateTime?.hour.toString().length == 1
        ? '0${dateTime?.hour}'
        : '${dateTime?.hour}';

    String _minute = dateTime?.minute.toString().length == 1
        ? '0${dateTime?.minute}'
        : '${dateTime?.minute}';

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
          child: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
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
              text:
                  // chat.lastMessage == null
                  // ? '' :
                  // TODO: PHASE CHECKLIST COMMENTS IS EMPTY
                  _isYesterday
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
