import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/screens/news_comments/news_comments_screen.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/bottom_button_widget.dart';
import 'package:izowork/views/title_widget.dart';

class NewsPageScreenWidget extends StatefulWidget {
  final String tag;
  const NewsPageScreenWidget({Key? key, required this.tag}) : super(key: key);

  @override
  _NewsScreenBodyState createState() => _NewsScreenBodyState();
}

class _NewsScreenBodyState extends State<NewsPageScreenWidget> {
  final dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _day = dateTime.day.toString().characters.length == 1
        ? '0${dateTime.day}'
        : '${dateTime.day}';
    final _month = dateTime.month.toString().characters.length == 1
        ? '0${dateTime.month}'
        : '${dateTime.month}';
    final _year = '${dateTime.year}';

    return Scaffold(
        backgroundColor: HexColors.white,
        body: Stack(children: [
          ListView(
              padding: EdgeInsets.only(
                  bottom: 70.0 + MediaQuery.of(context).padding.bottom),
              children: [
                /// IMAGE
                SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 4.0,
                    child: Hero(
                        tag: widget.tag,
                        child: SizedBox.expand(
                            child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        MediaQuery.of(context).padding.top == 0.0
                                            ? 0.0
                                            : 16.0),
                                    topRight: Radius.circular(
                                        MediaQuery.of(context).padding.top == 0.0
                                            ? 0.0
                                            : 16.0)),
                                child: CachedNetworkImage(
                                    imageUrl:
                                        'https://images.unsplash.com/photo-1554469384-e58fac16e23a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8YnVpbGRpbmd8ZW58MHx8MHx8&w=1000&q=80',
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height /
                                        4.0,
                                    memCacheWidth:
                                        (MediaQuery.of(context).size.width).round(),
                                    memCacheHeight: (MediaQuery.of(context).size.height / 4.0).round() * (MediaQuery.of(context).devicePixelRatio).round(),
                                    fit: BoxFit.cover))))),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 18.0, bottom: 10.0),
                    child: Row(children: [
                      /// NAME
                      Text('Имя Фамилия',
                          maxLines: 1,
                          style: TextStyle(
                              color: HexColors.grey40,
                              fontSize: 12.0,
                              fontFamily: 'PT Root UI')),
                      const SizedBox(width: 8.0),

                      /// DATE
                      Text('$_day.$_month.$_year',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: HexColors.grey40,
                              fontSize: 12.0,
                              fontFamily: 'PT Root UI'))
                    ])),
                const TitleWidget(text: 'Заголовок новости'),
                const SizedBox(height: 10.0),
                Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Text(
                        'Каждый из нас понимает очевидную вещь: семантический разбор внешних противодействий в значительной степени обусловливает важность укрепления моральных ценностей. Ясность нашей позиции очевидна: граница обучения кадров напрямую зависит от новых принципов формирования материально-технической и кадровой базы. Лишь стремящиеся вытеснить традиционное производство, нанотехнологии ограничены исключительно образом мышления. Современные технологии достигли такого уровня, что новая модель организационной деятельности обеспечивает широкому кругу (специалистов) участие в формировании укрепления моральных ценностей. Каждый из нас понимает очевидную вещь: базовый вектор развития предполагает независимые способы реализации новых принципов формирования материально-технической и кадровой базы. Каждый из нас понимает очевидную вещь: семантический разбор внешних противодействий в значительной степени обусловливает важность укрепления моральных ценностей. Ясность нашей позиции очевидна: граница обучения кадров напрямую зависит от новых принципов формирования материально-технической и кадровой базы. Лишь стремящиеся вытеснить традиционное производство, нанотехнологии ограничены исключительно образом мышления. Современные технологии достигли такого уровня, что новая модель организационной деятельности обеспечивает широкому кругу (специалистов) участие в формировании укрепления моральных ценностей. Каждый из нас понимает очевидную вещь: базовый вектор развития предполагает независимые способы реализации новых принципов формирования материально-технической и кадровой базы.',
                        style: TextStyle(
                            height: 1.4,
                            color: HexColors.black,
                            fontSize: 14.0,
                            fontFamily: 'PT Root UI'))),
              ]),

          /// BACK BUTTON
          SafeArea(
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      width: 40.0,
                      height: 40.0,
                      margin: const EdgeInsets.only(left: 16.0),
                      padding: const EdgeInsets.only(left: 7.0),
                      decoration: BoxDecoration(
                          color: HexColors.white,
                          border:
                              Border.all(width: 1.0, color: HexColors.grey20),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: ClipRRect(
                          child: BackButtonWidget(
                              onTap: () => Navigator.pop(context)))))),

          /// COMMENT BUTTON
          Align(
              alignment: Alignment.bottomCenter,
              child: BottomButtonWidget(
                  title: '${Titles.showAllComments} (15)', onTap: () =>  Navigator.push(context, MaterialPageRoute(
            builder: (context) =>   NewsCommentsScreenWidget(tag: widget.tag)))))
        ]));
  }
}
