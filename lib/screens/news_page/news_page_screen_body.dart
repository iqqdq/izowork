// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/screens/news_comments/news_comments_screen.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/views/views.dart';
import 'package:provider/provider.dart';

class NewsPageScreenBodyWidget extends StatefulWidget {
  const NewsPageScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _NewsPageScreenBodyState createState() => _NewsPageScreenBodyState();
}

class _NewsPageScreenBodyState extends State<NewsPageScreenBodyWidget> {
  final List<Widget> _images = [];
  late NewsPageViewModel _newsPageViewModel;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadImages());
  }

  @override
  Widget build(BuildContext context) {
    _newsPageViewModel = Provider.of<NewsPageViewModel>(
      context,
      listen: true,
    );

    Widget newsTitle = Padding(
      padding: EdgeInsets.only(
        top: _images.isEmpty ? 12.0 : 0.0,
        left: _images.isEmpty ? 52.0 : 0.0,
      ),
      child: TitleWidget(text: _newsPageViewModel.news?.name ?? ''),
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
        Expanded(
          child: Text(
            _newsPageViewModel.news?.user?.name ?? '-',
            maxLines: 1,
            style: TextStyle(
              color: HexColors.grey40,
              fontSize: 12.0,
              fontFamily: 'PT Root UI',
            ),
          ),
        ),
        const SizedBox(width: 8.0),

        /// DATE
        Text(
          _newsPageViewModel.news == null
              ? ''
              : DateTimeFormatter().formatDateTimeToString(
                  dateTime: _newsPageViewModel.news!.createdAt,
                  showTime: true,
                  showMonthName: true,
                ),
          textAlign: TextAlign.end,
          style: TextStyle(
            color: HexColors.grey40,
            fontSize: 12.0,
            fontFamily: 'PT Root UI',
          ),
        )
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
                      : ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0),
                          ),
                          child: Stack(children: [
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height / 3.5,
                              color: HexColors.grey30,
                            ),
                            ImageSlideshow(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height / 3.5,
                              children: _images,
                              initialPage: 0,
                              indicatorColor: HexColors.white,
                              indicatorBackgroundColor: HexColors.grey40,
                              indicatorRadius: _images.length == 1 ? 0.0 : 4.0,
                              autoPlayInterval: 6000,
                              isLoop: true,
                            ),

                            /// TAG
                            _newsPageViewModel.news == null
                                ? Container()
                                : _newsPageViewModel.news!.important
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
                          ]),
                        ),
                  _images.isEmpty ? Container() : authorWidget,

                  /// NEWS TITLE
                  _images.isEmpty ? newsTitle : newsTitle,
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
                      child: Text(
                        _newsPageViewModel.news?.description ?? '',
                        style: TextStyle(
                          height: 1.4,
                          color: HexColors.black,
                          fontSize: 14.0,
                          fontFamily: 'PT Root UI',
                        ),
                      ),
                    ),
                  ),
                ]),
          ),

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
          _newsPageViewModel.news == null
              ? Container()
              : Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomButtonWidget(
                    title: _newsPageViewModel.news!.commentsTotal == 0
                        ? Titles.addComment
                        : '${Titles.showAllComments} (${_newsPageViewModel.news!.commentsTotal})',
                    onTap: () => _showNewsCommentsScreen(),
                  ),
                ),

          /// INDICATOR
          _newsPageViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ]),
      ),
    );
  }

  void _loadImages() {
    if (_newsPageViewModel.news != null) {
      if (_newsPageViewModel.news!.files.isNotEmpty) {
        _newsPageViewModel.news!.files.forEach((element) {
          _images.add(
            CachedNetworkImage(
              imageUrl: newsMediaUrl + element.filename,
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 3.5,
              memCacheWidth: (MediaQuery.of(context).size.width - 32.0).round(),
              fit: BoxFit.cover,
            ),
          );
        });
      }
    }

    setState(() {});
  }

  void _showNewsCommentsScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NewsCommentsScreenWidget(news: _newsPageViewModel.news!)));
  }
}
