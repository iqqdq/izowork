import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/locale.dart';

class ObjectAnalitycsActionListItemWidget extends StatelessWidget {
  final String text;
  final DateTime dateTime;
  final VoidCallback onUserTap;

  const ObjectAnalitycsActionListItemWidget(
      {Key? key,
      required this.text,
      required this.dateTime,
      required this.onUserTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting(locale, null);

    final _minute = dateTime.minute.toString().length == 1
        ? '0${dateTime.minute}'
        : '${dateTime.minute}';
    final _hour = dateTime.hour.toString().length == 1
        ? '0${dateTime.hour}'
        : '${dateTime.hour}';
    final _day = dateTime.day.toString().length == 1
        ? '0${dateTime.day}'
        : '${dateTime.day}';
    final _month = DateFormat.MMM(locale).format(dateTime).toLowerCase();
    final _year = '${dateTime.year}';

    return Container(
            margin:
                const EdgeInsets.only(bottom: 10.0, left: 16.0, right: 16.0),
            decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: HexColors.grey20),
                borderRadius: BorderRadius.circular(16.0)),
            child:
                // Material(
                //     color: Colors.transparent,
                //     child: InkWell(
                //         highlightColor: HexColors.grey20,
                //         splashColor: Colors.transparent,
                //         borderRadius: BorderRadius.circular(16.0),
                //         child:
                ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16.0),
                    children: [
                  /// DATE
                  Text('$_hour:$_minute, $_day $_month $_year',
                      style: TextStyle(
                          color: HexColors.grey30,
                          fontSize: 14.0,
                          overflow: TextOverflow.ellipsis,
                          fontFamily: 'PT Root UI',
                          fontWeight: FontWeight.w500)),

                  const SizedBox(height: 6.0),

                  /// TEXT
                  Text(text,
                      style: TextStyle(
                          color: HexColors.black,
                          fontSize: 18.0,
                          fontFamily: 'PT Root UI')),
                  const SizedBox(height: 10.0),

                  /// USER
                  GestureDetector(
                      onTap: () => onUserTap(),
                      child: Row(children: [
                        /// AVATAR
                        Stack(children: [
                          SvgPicture.asset('assets/ic_avatar.svg',
                              width: 24.0,
                              height: 24.0,
                              fit: BoxFit.cover,
                              color: HexColors.grey50),
                          //   ClipRRect(
                          //   borderRadius: BorderRadius.circular(40.0),
                          //   child:
                          // CachedNetworkImage(imageUrl: '', width: 80.0, height: 80.0, cacheWidth: 80 * (MediaQuery.of(context).devicePixelRatio).round(), cacheHeight: 80 * (MediaQuery.of(context).devicePixelRatio).round(), fit: BoxFit.cover)),
                        ]),
                        const SizedBox(width: 10.0),

                        /// USERNAME
                        Expanded(
                            child: Text('Имя Фамилия',
                                style: TextStyle(
                                    color: HexColors.grey50,
                                    fontSize: 14.0,
                                    fontFamily: 'PT Root UI',
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold))),
                      ]))
                ]))
        // ))
        ;
  }
}
