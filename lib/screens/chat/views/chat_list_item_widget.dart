// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/locale.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/chat.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/views/count_widget.dart';
import 'package:izowork/views/title_widget.dart';

class ChatListItemWidget extends StatelessWidget {
  final Chat chat;
  final VoidCallback onTap;

  const ChatListItemWidget({Key? key, required this.chat, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting(locale, null);

    bool _isGroupChat = chat.chatType == "GROUP";

    DateTime? dateTime = chat.lastMessage == null
        ? null
        : chat.lastMessage!.createdAt.toUtc().toLocal();

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

    bool isAudio = chat.lastMessage == null
        ? false
        : chat.lastMessage!.files.isEmpty
            ? false
            : chat.lastMessage!.files.first.mimeType == null
                ? false
                : chat.lastMessage!.files.first.mimeType!.contains('audio') ||
                    chat.lastMessage!.files.first.name.contains('m4a');

    bool isFile = chat.lastMessage == null
        ? false
        : !isAudio && chat.lastMessage!.files.isNotEmpty;

    String? _url = chat.user?.avatar;

    return Container(
        decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 0.5, color: HexColors.grey20),
            ),
            color: chat.unreadCount > 0
                ? HexColors.additionalVioletLight
                : HexColors.white),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                highlightColor: HexColors.grey20,
                splashColor: Colors.transparent,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14.0, vertical: 10.0),
                    child: Row(children: [
                      /// USER AVATAR
                      Stack(children: [
                        Container(
                            width: 40.0,
                            height: 40.0,
                            padding: EdgeInsets.all(_isGroupChat ? 8.0 : 0.0),
                            decoration: BoxDecoration(
                                color: _isGroupChat
                                    ? HexColors.additionalViolet
                                        .withOpacity(0.8)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20.0)),
                            child: SvgPicture.asset(
                                _isGroupChat
                                    ? 'assets/ic_group.svg'
                                    : 'assets/ic_avatar.svg',
                                color: _isGroupChat
                                    ? HexColors.white
                                    : HexColors.grey30,
                                width: 40.0,
                                height: 40.0,
                                fit: BoxFit.cover)),
                        _url == null
                            ? Container()
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: CachedNetworkImage(
                                    cacheKey: _url,
                                    imageUrl: avatarUrl + _url,
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
                            /// USER NAME
                            Text(chat.user?.name ?? chat.name ?? '-',
                                maxLines: 1,
                                style: TextStyle(
                                    color: HexColors.grey50,
                                    fontSize: 14.0,
                                    fontFamily: 'PT Root UI',
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4.0),

                            /// MESSAGE TEXT
                            Text(
                                isAudio
                                    ? Titles.audioMessage
                                    : isFile
                                        ? Titles.file
                                        : chat.lastMessage?.text ?? '',
                                maxLines: 1,
                                style: TextStyle(
                                    color: HexColors.black,
                                    fontSize: 14.0,
                                    fontFamily: 'PT Root UI',
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w400))
                          ])),

                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            /// DATE
                            TitleWidget(
                                text: chat.lastMessage == null
                                    ? ''
                                    : _isYesterday
                                        ? 'Вчера, $_hour:$_minute'
                                        : _isToday
                                            ? 'Сегодня, $_hour:$_minute'
                                            : _year.isEmpty
                                                ? '$_day $_month, $_hour:$_minute'
                                                : '$_day $_month $_year, $_hour:$_minute',
                                padding: EdgeInsets.zero,
                                textAlign: TextAlign.end,
                                isSmall: true),
                            const SizedBox(height: 4.0),

                            /// MESSAGE COUNT
                            chat.unreadCount > 0
                                ? CountWidget(count: chat.unreadCount)
                                : const SizedBox(height: 20.0)
                          ]),
                    ])),
                onTap: () => onTap())));
  }
}
