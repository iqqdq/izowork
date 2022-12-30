// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/locale.dart';
import 'package:izowork/entities/chat.dart';
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
                      /// CREATOR
                      Row(children: [
                        /// CREATOR AVATAR
                        Stack(children: [
                          Image.asset('assets/ic_avatar.png'),
                          // ClipRRect(
                          //   borderRadius: BorderRadius.circular(12.0),
                          //   child:
                          // CachedNetworkImage(imageUrl: '', width: 24.0, height: 24.0, fit: BoxFit.cover)),
                        ]),
                        const SizedBox(width: 10.0),

                        /// USER NAME
                        Expanded(
                            child: Text('Имя собеседника',
                                style: TextStyle(
                                    color: HexColors.grey50,
                                    fontSize: 14.0,
                                    fontFamily: 'PT Root UI',
                                    fontWeight: FontWeight.w700))),
                        const SizedBox(width: 10.0),

                        /// MESSAGE COUNT
                        const CountWidget(count: 1)
                      ]),
                      const SizedBox(height: 10.0),

                      /// MESSAGE TEXT
                      Text(
                          'Мы вынуждены отталкиваться от того, что семантический разбор внешних противодействий играет определяющее.',
                          style: TextStyle(
                              color: HexColors.black,
                              fontSize: 14.0,
                              fontFamily: 'PT Root UI',
                              fontWeight: FontWeight.w400)),
                      const SizedBox(height: 10.0),

                      /// DATE
                      TitleWidget(
                          text: '$_day $_month $_year, $_hour:$_minute',
                          padding: EdgeInsets.zero,
                          isSmall: true),
                    ]),
                onTap: () => onTap())));
  }
}
