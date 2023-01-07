import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';

class CommentListItemWidget extends StatelessWidget {
  final String tag;
  final DateTime dateTime;
  final VoidCallback onTap;
  final VoidCallback onUserTap;
  final VoidCallback onShowCommentsTap;

  const CommentListItemWidget(
      {Key? key,
      required this.tag,
      required this.dateTime,
      required this.onTap,
      required this.onUserTap,
      required this.onShowCommentsTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _day = dateTime.day.toString().characters.length == 1
        ? '0${dateTime.day}'
        : '${dateTime.day}';
    final _month = dateTime.month.toString().characters.length == 1
        ? '0${dateTime.month}'
        : '${dateTime.month}';
    final _year = '${dateTime.year}';

    return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: HexColors.white,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(width: 0.5, color: HexColors.grey30)),
        child: InkWell(
            highlightColor: HexColors.grey20,
            splashColor: Colors.transparent,
            borderRadius: BorderRadius.circular(16.0),
            onTap: () => onTap(),
            child: ListView(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Column(children: [
                    InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(16.0),
                        child: Row(children: [
                          ///   AVATAR
                          Stack(children: [
                            Image.asset('assets/ic_avatar.png',
                                width: 24.0, height: 24.0, fit: BoxFit.cover),
                            // ClipRRect(
                            //   borderRadius: BorderRadius.circular(12.0),
                            //   child:
                            // CachedNetworkImage(imageUrl: '', width: 40.0, height: 40.0, fit: BoxFit.cover)),
                          ]),
                          const SizedBox(width: 10.0),

                          ///   NAME
                          Text('Имя сотрудника',
                              style: TextStyle(
                                  color: HexColors.grey50,
                                  fontSize: 14.0,
                                  fontFamily: 'PT Root UI',
                                  fontWeight: FontWeight.bold)),
                        ]),
                        onTap: () => onUserTap()),
                    const SizedBox(height: 12.0),

                    /// COMMENT
                    Text(
                        'Семантический разбор внешних противодействий играет определяющее значение для всех наших сотрудников.',
                        style: TextStyle(
                            color: HexColors.black,
                            fontSize: 14.0,
                            fontFamily: 'PT Root UI')),
                    const SizedBox(height: 10.0),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      /// DATE
                      Text('$_day.$_month.$_year',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: HexColors.grey40,
                              fontSize: 12.0,
                              fontFamily: 'PT Root UI'))
                    ])
                  ])
                ])));
  }
}
