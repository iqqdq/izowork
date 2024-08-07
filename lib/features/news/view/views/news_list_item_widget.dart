// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/views/views.dart';

class NewsListItemWidget extends StatefulWidget {
  final String tag;
  final News news;
  final VoidCallback onTap;
  final VoidCallback onUserTap;
  final VoidCallback onShowCommentsTap;

  const NewsListItemWidget({
    Key? key,
    required this.tag,
    required this.news,
    required this.onTap,
    required this.onUserTap,
    required this.onShowCommentsTap,
  }) : super(key: key);

  @override
  _NewsListItemState createState() => _NewsListItemState();
}

class _NewsListItemState extends State<NewsListItemWidget> {
  final List<Widget> _images = [];

  @override
  Widget build(BuildContext context) {
    if (widget.news.files.isNotEmpty &&
        _images.length != widget.news.files.length) {
      if (widget.news.files.isNotEmpty) {
        _images.clear();
        widget.news.files.forEach((element) {
          _images.add(Stack(children: [
            Stack(children: [
              CachedNetworkImage(
                  imageUrl: newsMediaUrl + element.filename,
                  width: MediaQuery.of(context).size.width - 32.0,
                  height: 180.0,
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
            ])
          ]));
        });
      }
    }

    Widget newsTitle = Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 16.0,
        bottom: 4.0,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Text(
          widget.news.name,
          maxLines: 2,
          style: TextStyle(
            color: HexColors.black,
            fontSize: 16.0,
            fontFamily: 'PT Root UI',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            width: 0.5,
            color: HexColors.grey30,
          )),
      child: InkWell(
        highlightColor: HexColors.grey20,
        splashColor: Colors.transparent,
        borderRadius: BorderRadius.circular(16.0),
        onTap: () => widget.onTap(),
        child: ListView(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
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
                              width: MediaQuery.of(context).size.width - 32.0,
                              height: 180.0,
                              children: _images,
                              initialPage: 0,
                              indicatorColor: HexColors.white,
                              indicatorBackgroundColor: HexColors.grey40,
                              indicatorRadius: _images.length == 1 ? 0.0 : 4.0,
                              autoPlayInterval: 6000,
                              isLoop: true,
                            ),

                            /// TAG
                            widget.news.important
                                ? const Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: 10.0, right: 10.0),
                                          child: FittedBox(
                                              child: StatusWidget(
                                                  title: Titles.important,
                                                  status: 0)))
                                    ],
                                  )
                                : Container(),
                          ])),
                    ),

              /// TITLE
              _images.isEmpty
                  ? Hero(
                      tag: widget.tag,
                      child: newsTitle,
                    )
                  : newsTitle,

              /// TEXT
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 10.0,
                ),
                child: Text(widget.news.description,
                    maxLines: 3,
                    style: TextStyle(
                      color: HexColors.black,
                      fontSize: 14.0,
                      fontFamily: 'PT Root UI',
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: widget.news.commentsTotal == 0 ? 0.0 : 10.0,
                ),
                child: Row(children: [
                  /// NAME
                  Expanded(
                    child: Text(widget.news.user?.name ?? '-',
                        maxLines: 1,
                        style: TextStyle(
                          color: HexColors.grey40,
                          fontSize: 12.0,
                          fontFamily: 'PT Root UI',
                        )),
                  ),
                  const SizedBox(width: 12.0),

                  /// DATE
                  Text(
                      DateTimeFormatter().formatDateTimeToString(
                        dateTime: widget.news.createdAt,
                        showTime: true,
                        showMonthName: true,
                      ),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: HexColors.grey40,
                        fontSize: 12.0,
                        fontFamily: 'PT Root UI',
                      ))
                ]),
              ),
              widget.news.commentsTotal == 0
                  ? Container()
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: HexColors.grey,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: ListView(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                borderRadius: BorderRadius.circular(16.0),
                                child: Row(children: [
                                  /// AVATAR

                                  AvatarWidget(
                                    url: avatarUrl,
                                    endpoint: widget.news.user?.avatar,
                                    size: 24.0,
                                  ),

                                  const SizedBox(width: 10.0),

                                  /// COMMENT NAME
                                  Text(widget.news.user?.name ?? '-',
                                      style: TextStyle(
                                        color: HexColors.grey50,
                                        fontSize: 14.0,
                                        fontFamily: 'PT Root UI',
                                        fontWeight: FontWeight.bold,
                                      )),
                                ]),
                                onTap: () => widget.onUserTap()),
                            const SizedBox(height: 12.0),

                            /// COMMENT
                            Text('${widget.news.lastComment?.comment}',
                                maxLines: 2,
                                style: TextStyle(
                                  color: HexColors.black,
                                  fontSize: 14.0,
                                  fontFamily: 'PT Root UI',
                                ))
                          ]),
                    ),

              /// SHOW ALL COMMENT's BUTTON
              TransparentButtonWidget(
                  title: widget.news.commentsTotal == 0
                      ? Titles.addComment
                      : '${Titles.showAllComments} (${widget.news.commentsTotal})',
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 3.0),
                  fontSize: 14.0,
                  onTap: () => widget.onShowCommentsTap())
            ]),
      ),
    );
  }
}
