import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/transparent_button_widget_widget.dart';

class NewsListItemWidget extends StatelessWidget {
  final String tag;
  final DateTime dateTime;
  final VoidCallback onTap;
  final VoidCallback onUserTap;
  final VoidCallback onShowCommentsTap;

  const NewsListItemWidget(
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
        decoration: BoxDecoration(
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
                  /// IMAGE
                  Hero(
                      tag: tag,
                      child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0)),
                          child: CachedNetworkImage(
                              imageUrl:
                                  'https://images.unsplash.com/photo-1554469384-e58fac16e23a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8YnVpbGRpbmd8ZW58MHx8MHx8&w=1000&q=80',
                              width: MediaQuery.of(context).size.width - 32.0,
                              height: 180.0,
                              memCacheWidth:
                                  (MediaQuery.of(context).size.width - 32.0)
                                      .round(),
                              memCacheHeight: 180 *
                                  (MediaQuery.of(context).devicePixelRatio)
                                      .round(),
                              fit: BoxFit.cover))),

                  /// TITLE
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      child: Text('Заголовок новости',
                          maxLines: 2,
                          style: TextStyle(
                              color: HexColors.black,
                              fontSize: 16.0,
                              fontFamily: 'PT Root UI',
                              fontWeight: FontWeight.bold))),

                  /// TEXT
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, bottom: 10.0),
                      child: Text(
                          'Мы вынуждены отталкиваться от того, что семантический разбор внешних противодействий играет определяющее.',
                          maxLines: 3,
                          style: TextStyle(
                              color: HexColors.black,
                              fontSize: 14.0,
                              fontFamily: 'PT Root UI'))),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, bottom: 10.0),
                      child: Row(children: [
                        /// NAME
                        Expanded(
                            child: Text('Имя Фамилия',
                                maxLines: 1,
                                style: TextStyle(
                                    color: HexColors.grey40,
                                    fontSize: 12.0,
                                    fontFamily: 'PT Root UI'))),
                        const SizedBox(width: 8.0),

                        /// DATE
                        Text('$_day.$_month.$_year',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: HexColors.grey40,
                                fontSize: 12.0,
                                fontFamily: 'PT Root UI'))
                      ])),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          color: HexColors.grey,
                          borderRadius: BorderRadius.circular(16.0)),
                      child: Column(children: [
                        InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(16.0),
                            child: Row(children: [
                              /// COMMENT AVATAR
                              Stack(children: [
                                Image.asset('assets/ic_avatar.png',
                                    width: 24.0,
                                    height: 24.0,
                                    fit: BoxFit.cover),
                                // ClipRRect(
                                //   borderRadius: BorderRadius.circular(12.0),
                                //   child:
                                // CachedNetworkImage(imageUrl: '', width: 40.0, height: 40.0, fit: BoxFit.cover)),
                              ]),
                              const SizedBox(width: 10.0),

                              /// COMMENT NAME
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
                            'Семантический разбор внешних противодействий играет определяющее...',
                            maxLines: 2,
                            style: TextStyle(
                                color: HexColors.black,
                                fontSize: 14.0,
                                fontFamily: 'PT Root UI'))
                      ])),

                  /// SHOW ALL COMMENT's BUTTON
                  TransparentButtonWidget(
                      title: '${Titles.showAllComments} (15)',
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 3.0),
                      fontSize: 14.0,
                      onTap: () => onShowCommentsTap())
                ])));
  }
}
