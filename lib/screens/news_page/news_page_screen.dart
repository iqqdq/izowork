// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/news.dart';
import 'package:izowork/screens/news_comments/news_comments_screen.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/bottom_button_widget.dart';
import 'package:izowork/views/status_widget.dart';
import 'package:izowork/views/title_widget.dart';

class NewsPageScreenWidget extends StatefulWidget {
  final News news;
  final String tag;

  const NewsPageScreenWidget({
    Key? key,
    required this.news,
    required this.tag,
  }) : super(key: key);

  @override
  _NewsScreenBodyState createState() => _NewsScreenBodyState();
}

class _NewsScreenBodyState extends State<NewsPageScreenWidget> {
  final List<Widget> _images = [];

  @override
  Widget build(BuildContext context) {
    final _day = widget.news.createdAt.day.toString().characters.length == 1
        ? '0${widget.news.createdAt.day}'
        : '${widget.news.createdAt.day}';
    final _month = widget.news.createdAt.month.toString().characters.length == 1
        ? '0${widget.news.createdAt.month}'
        : '${widget.news.createdAt.month}';
    final _year = '${widget.news.createdAt.year}';

    if (widget.news.files.isNotEmpty &&
        _images.length != widget.news.files.length) {
      if (widget.news.files.isNotEmpty) {
        _images.clear();
        widget.news.files.forEach((element) {
          _images.add(Stack(children: [
            CachedNetworkImage(
                imageUrl: newsMediaUrl + element.filename,
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 3.5,
                memCacheWidth:
                    (MediaQuery.of(context).size.width - 32.0).round(),
                fit: BoxFit.cover),

            /// TOP GRADIENT LAYER
            widget.news.important
                ? Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 3.5,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.center,
                            colors: [
                          Colors.black26,
                          Colors.transparent,
                        ])))
                : Container(),

            /// BOTTOM GRADIENT LAYER
            widget.news.important
                ? Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 3.5,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.center,
                            end: Alignment.bottomCenter,
                            colors: [
                          Colors.transparent,
                          Colors.black26,
                        ])))
                : Container(),
          ]));
        });
      }
    }

    Widget newsTitle = Padding(
      padding: EdgeInsets.only(
        top: _images.isEmpty ? 12.0 : 0.0,
        left: _images.isEmpty ? 52.0 : 0.0,
      ),
      child: TitleWidget(text: widget.news.name),
    );

    Widget authorWidget = Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 18.0,
        bottom: 12.0,
      ),
      child: Row(children: [
        /// NAME
        Text(
          widget.news.user?.name ?? '-',
          maxLines: 1,
          style: TextStyle(
            color: HexColors.grey40,
            fontSize: 12.0,
            fontFamily: 'PT Root UI',
          ),
        ),
        const SizedBox(width: 8.0),

        /// DATE
        Text('$_day.$_month.$_year',
            textAlign: TextAlign.end,
            style: TextStyle(
                color: HexColors.grey40,
                fontSize: 12.0,
                fontFamily: 'PT Root UI'))
      ]),
    );

    return Scaffold(
      body: SafeArea(
        top: _images.isEmpty,
        bottom: false,
        child: Stack(children: [
          Container(
              color: HexColors.white,
              child: ListView(
                  padding: EdgeInsets.only(
                      bottom: 70.0 + MediaQuery.of(context).padding.bottom),
                  children: [
                    /// SLIDESHOW
                    _images.isEmpty
                        ? Container()
                        : Hero(
                            tag: widget.tag,
                            child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                ),
                                child: Stack(children: [
                                  ImageSlideshow(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height /
                                        3.5,
                                    children: _images,
                                    initialPage: 0,
                                    indicatorColor: HexColors.white,
                                    indicatorBackgroundColor: HexColors.grey40,
                                    indicatorRadius:
                                        _images.length == 1 ? 0.0 : 4.0,
                                    autoPlayInterval: 6000,
                                    isLoop: true,
                                  ),

                                  /// TAG
                                  widget.news.important
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                              .padding
                                                              .top ==
                                                          0.0
                                                      ? 30.0
                                                      : MediaQuery.of(context)
                                                              .padding
                                                              .top +
                                                          10.0,
                                                  right: 10.0),
                                              child: const FittedBox(
                                                child: StatusWidget(
                                                  title: Titles.important,
                                                  status: 0,
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      : Container(),
                                ])),
                          ),
                    _images.isEmpty ? Container() : authorWidget,

                    /// NEWS TITLE
                    _images.isEmpty
                        ? Hero(
                            tag: widget.tag,
                            child: newsTitle,
                          )
                        : newsTitle,
                    const SizedBox(height: 10.0),

                    _images.isEmpty ? authorWidget : Container(),

                    /// NEWS TEXT
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 0.0,
                        left: 16.0,
                        right: 16.0,
                      ),
                      child: SelectionArea(
                          child: Text(widget.news.description,
                              style: TextStyle(
                                  height: 1.4,
                                  color: HexColors.black,
                                  fontSize: 14.0,
                                  fontFamily: 'PT Root UI'))),
                    ),
                  ])),

          /// BACK BUTTON
          SafeArea(
            top: _images.isNotEmpty,
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 40.0,
                height: 40.0,
                margin: const EdgeInsets.only(left: 10.0, top: 8.0),
                padding: const EdgeInsets.only(left: 7.0),
                decoration: BoxDecoration(
                    color: HexColors.white,
                    border: Border.all(width: 1.0, color: HexColors.grey20),
                    borderRadius: BorderRadius.circular(20.0)),
                child: ClipRRect(
                  child: BackButtonWidget(
                    onTap: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
          ),

          /// COMMENT BUTTON
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomButtonWidget(
                title: widget.news.commentsTotal == 0
                    ? Titles.addComment
                    : '${Titles.showAllComments} (${widget.news.commentsTotal})',
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsCommentsScreenWidget(
                          tag: widget.tag,
                          news: widget.news,
                        ),
                      ),
                    )),
          ),
        ]),
      ),
    );
  }
}
