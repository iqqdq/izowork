import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/news.dart';
import 'package:izowork/screens/news_comments/news_comments_screen.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/bottom_button_widget.dart';
import 'package:izowork/views/title_widget.dart';

class NewsPageScreenWidget extends StatefulWidget {
  final News news;
  final String tag;
  const NewsPageScreenWidget({Key? key,
  required this.news,
   required this.tag}) : super(key: key);

  @override
  _NewsScreenBodyState createState() => _NewsScreenBodyState();
}

class _NewsScreenBodyState extends State<NewsPageScreenWidget> {

  @override
  Widget build(BuildContext context) {

    final _day = widget.news.createdAt.day.toString().characters.length == 1
        ? '0${widget.news.createdAt.day}'
        : '${widget.news.createdAt.day}';
    final _month = widget.news.createdAt.month.toString().characters.length == 1
        ? '0${widget.news.createdAt.month}'
        : '${widget.news.createdAt.month}';
    final _year = '${widget.news.createdAt.year}';

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
                                    imageUrl: newsMediaUrl + widget.news.files.first.filename,
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
                      Text(widget.news.user.name,
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
widget.news.description,
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
                      margin: const EdgeInsets.only(left: 10.0, top: 8.0),
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
                  title: '${Titles.showAllComments} (???)', onTap: () =>  Navigator.push(context, MaterialPageRoute(
            builder: (context) =>   NewsCommentsScreenWidget(tag: widget.tag)))))
        ]));
  }
}
