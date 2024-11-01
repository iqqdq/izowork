import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/features/news/view_model/news_view_model.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/features/news/view/news_filter_sheet/news_filter_page_view_screen.dart';
import 'package:izowork/features/news/view/views/news_list_item_widget.dart';
import 'package:izowork/features/news_comments/view/news_comments_screen.dart';
import 'package:izowork/features/news_create/view/news_create_screen.dart';
import 'package:izowork/features/news_page/view/news_page_screen.dart';
import 'package:izowork/views/views.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class NewsScreenBodyWidget extends StatefulWidget {
  const NewsScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _NewsScreenBodyState createState() => _NewsScreenBodyState();
}

class _NewsScreenBodyState extends State<NewsScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final ScrollController _scrollController = ScrollController();

  late NewsViewModel _newsViewModel;

  Pagination _pagination = Pagination();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.increase();
        _newsViewModel.getNews(
          pagination: _pagination,
          search: _textEditingController.text,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _newsViewModel = Provider.of<NewsViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
      backgroundColor: HexColors.white,
      appBar: AppBar(
          toolbarHeight: 116.0,
          titleSpacing: 0.0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Column(children: [
            Stack(children: [
              Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: BackButtonWidget(onTap: () => Navigator.pop(context))),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(Titles.news,
                    style: TextStyle(
                        color: HexColors.black,
                        fontSize: 18.0,
                        fontFamily: 'PT Root UI',
                        fontWeight: FontWeight.bold)),
              ])
            ]),
            const SizedBox(height: 16.0),
            Row(children: [
              Expanded(
                  child:

                      /// SEARCH INPUT
                      InputWidget(
                          textEditingController: _textEditingController,
                          focusNode: _focusNode,
                          margin: const EdgeInsets.symmetric(horizontal: 16.0),
                          isSearchInput: true,
                          placeholder: '${Titles.search}...',
                          onTap: () => setState,
                          onChange: (text) => {
                                setState(() => _isSearching = true),
                                EasyDebounce.debounce('news_debouncer',
                                    const Duration(milliseconds: 500),
                                    () async {
                                  _pagination = Pagination();

                                  _newsViewModel
                                      .getNews(
                                          pagination: _pagination,
                                          search: _textEditingController.text)
                                      .then((value) =>
                                          setState(() => _isSearching = false));
                                })
                              },
                          onClearTap: () => {
                                _newsViewModel.resetFilter(),
                                _onRefresh(),
                              }))
            ])
          ])),
      floatingActionButton: FloatingButtonWidget(
          onTap: () => _showNewsCreationScreen(
                _pagination,
                _textEditingController.text,
              )),
      body: SizedBox.expand(
        child: Stack(children: [
          /// NEWS LIST VIEW
          LiquidPullToRefresh(
            color: HexColors.primaryMain,
            backgroundColor: HexColors.white,
            springAnimationDurationInMilliseconds: 300,
            onRefresh: _onRefresh,
            child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                  bottom: 80.0 + MediaQuery.of(context).padding.bottom,
                ),
                itemCount: _newsViewModel.news.length,
                itemBuilder: (context, index) {
                  final news = _newsViewModel.news[index];

                  return NewsListItemWidget(
                    key: ValueKey(news.id),
                    tag: index.toString(),
                    news: news,
                    onTap: () => _showNewsPageScreen(news.id),
                    onUserTap: () => {},
                    onShowCommentsTap: () => _showNewsCommentsScreen(news),
                  );
                }),
          ),
          const SeparatorWidget(),

          /// EMPTY LIST TEXT
          _newsViewModel.loadingStatus == LoadingStatus.completed &&
                  _newsViewModel.news.isEmpty &&
                  !_isSearching
              ? const NoResultTitle()
              : Container(),

          /// FILTER BUTTON
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FilterButtonWidget(
                isSelected: _newsViewModel.newsFilter != null,
                onTap: () => _showNewsFilterSheet(),
              ),
            ),
          ),

          /// INDICATOR
          _newsViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ]),
      ),
    );
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future _onRefresh() async {
    _pagination = Pagination();
    await _newsViewModel.getNews(
      pagination: _pagination,
      search: _textEditingController.text,
    );
  }

  // MARK: -
  // MARK: - PUSH

  void _showNewsFilterSheet() => showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withValues(alpha: 0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => NewsFilterPageViewScreenWidget(
            newsFilter: _newsViewModel.newsFilter,
            onPop: (newsFilter) => {
                  newsFilter == null
                      ? _newsViewModel.resetFilter()
                      : _newsViewModel.setFilter(newsFilter),
                  _onRefresh(),
                }),
      );

  void _showNewsCreationScreen(
    Pagination pagination,
    String search,
  ) =>
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsCreateScreenWidget(
              onPop: (news) => {
                    pagination.offset = 0,
                    _newsViewModel.getNews(
                      pagination: pagination,
                      search: search,
                    ),
                    Toast().showTopToast(Titles.newsWasAdded)
                  }),
        ),
      );

  void _showNewsPageScreen(String id) => Navigator.push(context,
      MaterialPageRoute(builder: (context) => NewsPageScreenWidget(id: id)));

  void _showNewsCommentsScreen(News news) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NewsCommentsScreenWidget(news: news)));
}
