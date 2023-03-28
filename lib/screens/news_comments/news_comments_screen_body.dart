// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/models/news_comments_view_model.dart';
import 'package:izowork/screens/news_comments/views/comment_list_item_widget.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/views/chat_message_bar_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:provider/provider.dart';

class NewsCommentsScreenBodyWidget extends StatefulWidget {
  final String tag;

  const NewsCommentsScreenBodyWidget({Key? key, required this.tag})
      : super(key: key);

  @override
  _NewsCommentsScreenBodyState createState() => _NewsCommentsScreenBodyState();
}

class _NewsCommentsScreenBodyState extends State<NewsCommentsScreenBodyWidget> {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final List<Widget> _images = [];

  final List<Widget> _bubbles = [];

  late NewsCommentsViewModel _newsCommentsViewModel;

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void _updateBubble() {
    _bubbles.clear();

    if (mounted) {
      setState(() {
        int index = 0;
        _newsCommentsViewModel.comments.forEach((element) {
          _bubbles.add(CommentBubbleWidget(
              comment: _newsCommentsViewModel.comments[index],
              animate: _newsCommentsViewModel.comment?.id == element.id,
              onUserTap: () =>
                  _newsCommentsViewModel.showProfileScreen(context, index)));
          index++;
        });
      });
    }

    if (_newsCommentsViewModel.comment != null) {
      Future.delayed(const Duration(milliseconds: 300), () => _scrollDown());
      _newsCommentsViewModel.clearComment();
    }
  }

  void _scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    _newsCommentsViewModel =
        Provider.of<NewsCommentsViewModel>(context, listen: true);

    if (_newsCommentsViewModel.news.files.isNotEmpty &&
        _images.length != _newsCommentsViewModel.news.files.length) {
      if (_newsCommentsViewModel.news.files.isNotEmpty) {
        _images.clear();
        _newsCommentsViewModel.news.files.forEach((element) {
          _images.add(CachedNetworkImage(
              imageUrl: newsMediaUrl + element.filename,
              width: 85,
              height: 47.0,
              memCacheWidth:
                  85 * (MediaQuery.of(context).devicePixelRatio).round(),
              fit: BoxFit.cover));
        });
      }
    }

    final _day = _newsCommentsViewModel.news.createdAt.day
                .toString()
                .characters
                .length ==
            1
        ? '0${_newsCommentsViewModel.news.createdAt.day}'
        : '${_newsCommentsViewModel.news.createdAt.day}';
    final _month = _newsCommentsViewModel.news.createdAt.month
                .toString()
                .characters
                .length ==
            1
        ? '0${_newsCommentsViewModel.news.createdAt.month}'
        : '${_newsCommentsViewModel.news.createdAt.month}';
    final _year = '${_newsCommentsViewModel.news.createdAt.year}';

    if (_newsCommentsViewModel.comments.isNotEmpty &&
        _newsCommentsViewModel.comment == null) {
      if (_bubbles.length < _newsCommentsViewModel.comments.length) {
        _updateBubble();
      }
    }

    return Scaffold(
        backgroundColor: HexColors.white,
        appBar: AppBar(
            toolbarHeight: 84.0,
            titleSpacing: 16.0,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Row(children: [
              BackButtonWidget(onTap: () => Navigator.pop(context)),
              const SizedBox(width: 12.0),

              /// IMAGE
              Hero(
                tag: widget.tag,
                child:

                    /// SLIDESHOW
                    ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: _images.isEmpty
                            ? Container()
                            : ImageSlideshow(
                                width: 85,
                                height: 47.0,
                                children: _images,
                                initialPage: 0,
                                indicatorColor: HexColors.white,
                                indicatorBackgroundColor: HexColors.grey40,
                                indicatorRadius:
                                    _images.length == 1 ? 0.0 : 4.0,
                                autoPlayInterval: 6000,
                                isLoop: true)),
              ),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    TitleWidget(
                        text: _newsCommentsViewModel.news.user.name,
                        isSmall: true),
                    TitleWidget(text: _newsCommentsViewModel.news.name),
                    TitleWidget(text: '$_day.$_month.$_year', isSmall: true)
                  ]))
            ])),
        body: SizedBox.expand(
            child: Stack(children: [
          Column(children: [
            _newsCommentsViewModel.comments.isEmpty
                ? Container()
                : Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 6.0),
                    width: double.infinity,
                    color: HexColors.grey20,
                    child: Text(
                        '${Titles.comments} (${_newsCommentsViewModel.comments.length}):',
                        style: TextStyle(
                            color: HexColors.black,
                            fontSize: 14.0,
                            fontFamily: 'PT Root UI',
                            fontWeight: FontWeight.w500))),
            Expanded(
                child: Container(
                    color: HexColors.grey10,
                    child:

                        /// COMMENTS LIST VIEW
                        GestureDetector(
                            onTap: () => FocusScope.of(context).unfocus(),
                            child: ListView.builder(
                                controller: _scrollController,
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(
                                    left: 16.0,
                                    right: 16.0,
                                    top: 12.0,
                                    bottom: 12.0),
                                itemCount:
                                    _newsCommentsViewModel.comments.length,
                                itemBuilder: (context, index) =>
                                    _bubbles[index])))),
            Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom == 0.0
                            ? 0.0
                            : MediaQuery.of(context).padding.bottom * 0.75),
                    child: ChatMessageBarWidget(
                        textEditingController: _textEditingController,
                        focusNode: _focusNode,
                        hintText: Titles.comment + '...',
                        onSendTap: () => {
                              /// SEND COMMENT
                              _newsCommentsViewModel
                                  .createNewsComment(
                                      context, _textEditingController.text)
                                  .then((value) => {
                                        /// CLEAR INPUT
                                        _textEditingController.clear(),

                                        /// UPDATE BUBBLE
                                        if (_newsCommentsViewModel.comment !=
                                            null)
                                          {_updateBubble()}
                                      })
                            }))),
          ]),

          /// EMPTY LIST TEXT
          _newsCommentsViewModel.loadingStatus == LoadingStatus.completed &&
                  _newsCommentsViewModel.comments.isEmpty
              ? Center(
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 100.0),
                      child: Text(Titles.noResult,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              color: HexColors.grey50))))
              : Container(),

          /// INDICATOR
          _newsCommentsViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
