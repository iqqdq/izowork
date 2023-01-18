// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/locale.dart';
import 'package:izowork/entities/chat.dart';
import 'package:izowork/views/count_widget.dart';
import 'package:izowork/views/title_widget.dart';

class ChatListItemWidget extends StatelessWidget {
  final Chat chat;
  final bool isUnread;
  final VoidCallback onTap;

  const ChatListItemWidget(
      {Key? key,
      required this.chat,
      required this.isUnread,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting(locale, null);

    final _day = DateTime.now().day.toString().length == 1
        ? '0${DateTime.now().day}'
        : '${DateTime.now().day}';
    final _month = DateFormat.MMM(locale).format(DateTime.now());
    final _year = '${DateTime.now().year}';

    final _hour = DateTime.now().hour.toString().length == 1
        ? '0${DateTime.now().hour}'
        : '${DateTime.now().hour}';

    final _minute = DateTime.now().minute.toString().length == 1
        ? '0${DateTime.now().minute}'
        : '${DateTime.now().minute}';

    return Container(
        decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 0.5, color: HexColors.grey20),
            ),
            color:
                isUnread ? HexColors.additionalVioletLight : HexColors.white),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                highlightColor: HexColors.grey20,
                splashColor: Colors.transparent,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14.0, vertical: 10.0),
                    child: Row(children: [
                      /// CREATOR AVATAR
                      Stack(children: [
                        SvgPicture.asset('assets/ic_avatar.svg',
                            color: HexColors.grey40,
                            width: 40.0,
                            height: 40.0,
                            fit: BoxFit.cover),
                        // ClipRRect(
                        //   borderRadius: BorderRadius.circular(12.0),
                        //   child:
                        // CachedNetworkImage(imageUrl: '', width: 24.0, height: 24.0, fit: BoxFit.cover)),
                      ]),
                      const SizedBox(width: 10.0),

                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            /// USER NAME
                            Text('Имя собеседника',
                                maxLines: 1,
                                style: TextStyle(
                                    color: HexColors.grey50,
                                    fontSize: 14.0,
                                    fontFamily: 'PT Root UI',
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4.0),

                            /// MESSAGE TEXT
                            Text(
                                'Мы вынуждены отталкиваться от того, что семантический разбор внешних противодействий играет определяющее.',
                                maxLines: 1,
                                style: TextStyle(
                                    color: HexColors.black,
                                    fontSize: 14.0,
                                    fontFamily: 'PT Root UI',
                                    fontWeight: FontWeight.w400))
                          ])),

                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            /// DATE
                            TitleWidget(
                                text: '$_day $_month $_year, $_hour:$_minute',
                                padding: EdgeInsets.zero,
                                isSmall: true),
                            const SizedBox(height: 4.0),

                            /// MESSAGE COUNT
                            isUnread ? const CountWidget(count: 1) : Container()
                          ]),
                    ])),
                onTap: () => onTap())));
  }
}
